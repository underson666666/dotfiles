"""Cross-platform Codex Stop hook. Runtime dependencies: Python and Git only."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import time


HOOK_DIR = Path(__file__).resolve().parent
ROOT = HOOK_DIR.parent.parent
MAX_FAILURES = 5
PYTEST_TIMEOUT = 120
OUTPUT_LIMIT = 12000


def changed_python(status):
    """Parse porcelain v1 -z, including both paths of renames and copies."""
    entries = iter(status.split(b"\0"))
    found = False
    for entry in entries:
        if not entry:
            continue
        if len(entry) < 4 or entry[2:3] != b" ":
            raise ValueError("git statusの形式が不正です")
        paths = [entry[3:]]
        if b"R" in entry[:2] or b"C" in entry[:2]:
            source = next(entries, None)
            if not source:
                raise ValueError("名前変更元のパスがありません")
            paths.append(source)
        found = found or any(path.endswith(b".py") for path in paths)
    return found


def pytest_python():
    venv = ROOT / ".venv"
    candidate = venv / ("Scripts/python.exe" if os.name == "nt" else "bin/python")
    if venv.exists():
        if not candidate.is_file():
            raise RuntimeError(f"このOS用の仮想環境がありません: {candidate}")
        return str(candidate)
    return sys.executable


def run_pytest():
    """Capture to disk rather than retaining arbitrarily large output in RAM."""
    with tempfile.TemporaryFile() as output:
        try:
            result = subprocess.run(
                [pytest_python(), "-m", "pytest"], cwd=ROOT,
                stdin=subprocess.DEVNULL, stdout=output, stderr=subprocess.STDOUT,
                timeout=PYTEST_TIMEOUT, check=False,
            )
            code = result.returncode
        except subprocess.TimeoutExpired:
            code = None
        output.seek(0, os.SEEK_END)
        output.seek(max(0, output.tell() - OUTPUT_LIMIT))
        tail = output.read().decode("utf-8", errors="replace")
    labels = {
        0: "成功", 1: "テスト失敗", 2: "収集エラーまたは実行中断",
        3: "pytest内部エラー", 4: "pytest使用方法・設定エラー",
        5: "テストが見つかりません", None: "pytestタイムアウト",
    }
    label = labels.get(code, f"pytest異常終了 (exit={code})")
    if "No module named pytest" in tail:
        label = "pytestがインストールされていません"
    return code == 0, label, tail


def save_state(path, state):
    temporary = path.with_suffix(".tmp")
    temporary.write_text(json.dumps(state, ensure_ascii=False), encoding="utf-8")
    temporary.replace(path)


def check(session_id, human_required=False, retry=False):
    if (HOOK_DIR / "pytest.disable").exists():
        return {"systemMessage": "pytest.disableがあるためpytestを省略しました。"}

    digest = hashlib.sha256(session_id.encode("utf-8")).hexdigest()
    directory = HOOK_DIR / ".state" / digest
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    lock = directory / "lock"
    deadline = time.monotonic() + 5
    while True:
        try:
            lock.mkdir()
            break
        except FileExistsError:
            if time.monotonic() >= deadline:
                raise RuntimeError(f"チェックが実行中かロックが残っています: {lock}")
            time.sleep(0.1)
    try:
        path = directory / "state.json"
        state = json.loads(path.read_text(encoding="utf-8")) if path.exists() else {"failures": 0}
        failures = state["failures"]
        if type(failures) is not int or not 0 <= failures <= MAX_FAILURES:
            raise ValueError("失敗回数の状態が不正です")
        paused = bool(state.get("paused"))
        if not retry and (paused or (failures > 0 and human_required)):
            save_state(path, {"failures": failures, "paused": True})
            return {"systemMessage": "人間の対応が必要なためpytestの自動修正を停止しました。検証は未完了です。対処後に --retry で再検査できます。"}
        if not retry and failures >= MAX_FAILURES:
            return {"systemMessage": "pytestチェックは5回連続失敗のため停止中です。人間への報告後、--retry で再検査できます。"}
        try:
            if not retry:
                result = subprocess.run(
                    ["git", "status", "--porcelain=v1", "-z", "--untracked-files=all"],
                    cwd=ROOT, stdin=subprocess.DEVNULL, stdout=subprocess.PIPE,
                    stderr=subprocess.PIPE, timeout=15, check=False,
                )
                if result.returncode:
                    raise RuntimeError("git status失敗: " + result.stderr.decode("utf-8", errors="replace")[-2000:])
                if not changed_python(result.stdout):
                    return {}
            success, label, tail = run_pytest()
        except (OSError, RuntimeError, ValueError, subprocess.TimeoutExpired) as error:
            success, label, tail = False, "検査の実行エラー", str(error)

        if success:
            save_state(path, {"failures": 0})
            return {}

        failures = min(failures + 1, MAX_FAILURES)
        log = directory / "last-output.txt"
        log.write_text(label + "\n" + tail, encoding="utf-8")
        save_state(path, {"failures": failures, "error": label, "paused": paused})
        details = f"{label}。連続失敗 {failures}/{MAX_FAILURES}。\nログ: {log}\n{tail[-6000:]}"
        if retry and (paused or failures == MAX_FAILURES):
            instruction = "再チェックも失敗したため停止状態を維持します。自動修正と再テストを中止し、人間に結果を報告してください。"
        elif failures == MAX_FAILURES:
            instruction = "自動修正と再テストを中止してください。人間に5回連続失敗した旨、原因、試した対応、未検証事項を日本語で報告してください。"
        else:
            instruction = "失敗原因を確認し、修正可能なら修正して再度終了してください。人間の操作・判断が必要なら修正せず、最終応答を『人間の対応が必要です:』で始めて原因と必要な操作を報告してください。pytest.disableを作成・変更してはいけません。"
        return {"decision": "block", "reason": instruction + "\n" + details}
    finally:
        lock.rmdir()


def main(argv=()):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--retry", action="store_true", help="停止中でも1回pytestを再実行する")
    parser.add_argument("--session-id", help="再検査対象。省略時はCODEX_THREAD_IDを使用")
    args = parser.parse_args(argv)
    try:
        if args.session_id and not args.retry:
            raise ValueError("--session-id は --retry と組み合わせてください")
        payload = (
            {"session_id": args.session_id or os.environ.get("CODEX_THREAD_ID")}
            if args.retry else json.load(sys.stdin)
        )
        session_id = payload.get("session_id")
        if not isinstance(session_id, str) or not session_id:
            raise ValueError("session_idがありません。--retry では --session-id を指定するかCodex内で実行してください")
        message = payload.get("last_assistant_message")
        human_required = (
            payload.get("stop_hook_active") is True
            and isinstance(message, str)
            and message.lstrip().startswith("人間の対応が必要です:")
        )
        output = check(session_id, human_required=human_required, retry=args.retry)
        if args.retry and output == {}:
            output = {"systemMessage": "再チェック成功。失敗回数を0に戻し、停止状態を解除しました。"}
    except Exception as error:
        # State/input failures cannot safely maintain a bounded retry loop.
        output = {
            "continue": False,
            "systemMessage": f"pytestフック自体の異常で検査できませんでした。成功扱いにせず、人間に報告してください: {error}",
        }
    print(json.dumps(output, ensure_ascii=True))
    return int(args.retry and (output.get("decision") == "block" or output.get("continue") is False))


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
