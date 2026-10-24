"""Install project-local pytest Stop hooks without replacing unrelated settings."""

import argparse
import copy
import hashlib
import json
import os
from pathlib import Path
import sys
import tempfile
import uuid


SOURCE = Path(__file__).resolve().parent / "pytest_stop.py"
SCRIPT = Path(".codex/hooks/pytest_stop.py")
MANIFEST = Path(".codex/hooks/setup-manifest.json")
CONFIGS = {"codex": Path(".codex/hooks.json"), "claude": Path(".claude/settings.json")}
BOOTSTRAP = "import pathlib,runpy; p=next(p for p in (pathlib.Path.cwd(), *pathlib.Path.cwd().parents) if (p/'.codex/hooks/pytest_stop.py').is_file()); runpy.run_path(str(p/'.codex/hooks/pytest_stop.py'),run_name='__main__')"


def handler(tool):
    value = {"type": "command", "timeout": 180,
             "statusMessage": "Pythonの変更とpytestの結果を確認しています"}
    if tool == "codex":
        value.update(command=f'python3 -c "{BOOTSTRAP}"', commandWindows=f'py -3 -c "{BOOTSTRAP}"')
    else:
        value["command"] = 'python3 "$CLAUDE_PROJECT_DIR/.codex/hooks/pytest_stop.py"'
    return value


def safe_path(root, relative):
    path = root
    for part in relative.parts:
        path = path / part
        if path.is_symlink():
            raise ValueError(f"シンボリックリンクは変更しません: {path}")
    if path.exists() and not path.is_file():
        raise ValueError(f"通常ファイルではありません: {path}")
    return path


def read_json(path):
    data = json.loads(path.read_text(encoding="utf-8")) if path.exists() else {}
    if not isinstance(data, dict):
        raise ValueError(f"JSONオブジェクトが必要です: {path}")
    return data


def stop_groups(config):
    hooks = config.get("hooks", {})
    if not isinstance(hooks, dict) or not isinstance(hooks.get("Stop", []), list):
        raise ValueError("hooks / Stop の形式が不正です")
    groups = hooks.get("Stop", [])
    for group in groups:
        if not isinstance(group, dict) or not isinstance(group.get("hooks"), list):
            raise ValueError("Stopフックの形式が不正です")
        if any(not isinstance(item, dict) for item in group["hooks"]):
            raise ValueError("フックの形式が不正です")
    return groups


def encoded(data):
    return (json.dumps(data, ensure_ascii=False, indent=2) + "\n").encode("utf-8")


def digest(data):
    return hashlib.sha256(data).hexdigest()


def plan(root, action, selected):
    """Validate everything before returning a list of (path, old, new) changes."""
    paths = {tool: safe_path(root, path) for tool, path in CONFIGS.items()}
    configs = {tool: read_json(path) for tool, path in paths.items()}
    for config in configs.values():
        stop_groups(config)
    manifest_path = safe_path(root, MANIFEST)
    script_path = safe_path(root, SCRIPT)
    manifest = read_json(manifest_path)
    if manifest and (manifest.get("version") != 1 or not isinstance(manifest.get("tools"), dict)):
        raise ValueError("管理情報の形式が不正です")
    if not manifest:
        manifest = {"version": 1, "tools": {}, "script_hash": None}
    if any(tool not in CONFIGS or not isinstance(entry, dict)
           for tool, entry in manifest["tools"].items()):
        raise ValueError("管理対象ツールの情報が不正です")
    changes = []

    def add(path, new):
        old = path.read_bytes() if path.exists() else None
        if old != new:
            changes.append((path, old, new))

    if action == "install":
        source = SOURCE.read_bytes()
        if script_path.exists() and script_path.read_bytes() != source:
            if manifest["script_hash"] != digest(script_path.read_bytes()):
                raise ValueError("既存のpytest_stop.pyは管理外または手動変更済みです。上書きしません")
        if not script_path.exists() or manifest["script_hash"]:
            manifest["script_hash"] = digest(source)
        add(script_path, source)

    for tool in selected:
        config = configs[tool]
        groups = stop_groups(config)
        owned = manifest["tools"].get(tool)
        expected = handler(tool)
        if action == "uninstall" and not owned:
            continue
        if owned:
            matches = [(group, item) for group in groups for item in group["hooks"] if item == owned]
            if len(matches) != 1:
                raise ValueError(f"{tool}: 登録済みフックが変更または削除されています。自動変更を中止します")
            group, item = matches[0]
            if action == "uninstall" or item != expected:
                group["hooks"].remove(item)
                if not group["hooks"] and set(group) == {"hooks"}:
                    groups.remove(group)
                del manifest["tools"][tool]
            elif action == "install":
                continue
        if action == "install":
            existing = [item for group in groups for item in group["hooks"]
                        if "pytest_stop.py" in json.dumps(item)]
            if existing:
                if existing == [expected]:
                    print(f"保持: {tool} は既に設定済み（管理外のため削除対象にしません）")
                    continue
                raise ValueError(f"{tool}: 既存のpytest_stop.py設定と競合しています")
            config.setdefault("hooks", {}).setdefault("Stop", []).append({"hooks": [expected]})
            manifest["tools"][tool] = copy.deepcopy(expected)
        add(paths[tool], encoded(config))

    if action == "uninstall" and not manifest["tools"] and manifest["script_hash"]:
        referenced = any("pytest_stop.py" in json.dumps(config) for config in configs.values())
        if not referenced and script_path.exists():
            if digest(script_path.read_bytes()) == manifest["script_hash"]:
                add(script_path, None)
                manifest["script_hash"] = None
            else:
                print("保持: pytest_stop.py は手動変更済みです")
    if manifest_path.exists() or manifest["tools"] or manifest["script_hash"]:
        add(manifest_path, encoded(manifest))
    return changes


def apply(changes, dry_run=False):
    # Refuse stale plans before creating backups or writing anything.
    for path, old, new in changes:
        if (path.read_bytes() if path.exists() else None) != old:
            raise ValueError(f"計画後にファイルが変更されました: {path}")
    for path, old, new in changes:
        verb = "削除" if new is None else "作成" if old is None else "更新"
        print(f"{'[dry-run] ' if dry_run else ''}{verb}: {path}")
        if dry_run:
            if old is not None:
                print(f"  バックアップ予定: {path.name}.bak-<ランダムID>")
            continue
        path.parent.mkdir(parents=True, exist_ok=True)
        if old is not None:
            backup = path.with_name(path.name + ".bak-" + uuid.uuid4().hex)
            with backup.open("xb") as stream:
                os.chmod(backup, 0o600)
                stream.write(old)
            print(f"  バックアップ: {backup}")
        if new is None:
            path.unlink()
        else:
            fd, temporary = tempfile.mkstemp(prefix=".setup-", dir=path.parent)
            try:
                with os.fdopen(fd, "wb") as stream:
                    stream.write(new)
                os.replace(temporary, path)
            finally:
                if os.path.exists(temporary):
                    os.unlink(temporary)


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["install", "uninstall"])
    parser.add_argument("--target", type=Path, required=True)
    parser.add_argument("--tool", choices=["codex", "claude", "both"], required=True)
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args(argv)
    try:
        root = args.target.expanduser().resolve()
        if not root.is_dir():
            raise ValueError("--targetには既存のプロジェクトディレクトリを指定してください")
        selected = list(CONFIGS) if args.tool == "both" else [args.tool]
        changes = plan(root, args.action, selected)
        apply(changes, args.dry_run)
        if not changes:
            print("変更はありません")
        return 0
    except (OSError, ValueError, KeyError) as error:
        print(f"エラー: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
