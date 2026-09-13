#!/usr/bin/env python3
import json, sys, os, re

try:
    if sys.platform == 'win32':
        sys.stdin.reconfigure(encoding='utf-8')   # Windows必須
        sys.stdout.reconfigure(encoding='utf-8')  # Windows必須

    data = json.load(sys.stdin)

    R      = '\033[0m'
    DIM    = '\033[2m'
    GREEN  = '\033[92m'
    YELLOW = '\033[33m'
    RED    = '\033[31m'

    def color(pct):
        if pct <= 30:
            return GREEN
        elif pct <= 60:
            return YELLOW
        else:
            return RED

    def fmt_bar(label, pct):
        p = round(pct)
        filled = p * 10 // 100
        bar = '▓' * filled + '░' * (10 - filled)
        return f'{label} {color(p)}{bar} {p}%{R}'

    NOTIFICATION_RE = re.compile(r'<task-id>(.*?)</task-id>.*?<status>(.*?)</status>', re.S)

    def count_running_agents(transcript_path):
        # 各agentIdの状態(running/completed)を時系列で追跡する。
        # SendMessageでresumeされたエージェントは一度completedになった後も
        # 再度runningに戻るため、launched/completedの単純な集合差分では
        # resume中の実行状態を検出できない。
        if not transcript_path or not os.path.isfile(transcript_path):
            return 0
        state = {}
        try:
            with open(transcript_path, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if not line:
                        continue
                    try:
                        obj = json.loads(line)
                    except ValueError:
                        continue
                    tur = obj.get('toolUseResult')
                    if isinstance(tur, dict):
                        if tur.get('isAsync') and tur.get('agentId'):
                            state[tur['agentId']] = 'running'
                        if tur.get('resumedAgentId'):
                            state[tur['resumedAgentId']] = 'running'
                    # 通知はuserメッセージ本文やqueue-operationのcontentなど複数の形で来るため、行全体を対象に検索する
                    if '<task-notification>' in line:
                        for task_id, status in NOTIFICATION_RE.findall(line):
                            if status.strip() == 'completed':
                                state[task_id.strip()] = 'completed'
        except OSError:
            return 0
        return sum(1 for v in state.values() if v == 'running')

    model = data.get('model', {}).get('display_name', 'Claude')
    effort = data.get('effort', {}).get('level')
    if effort:
        model = f'{model}({effort})'
    parts = [model]

    # ディレクトリ名
    cwd = data.get('workspace', {}).get('current_dir', '')
    if cwd:
        parts.append(os.path.basename(cwd))

    # 現在実行中のサブエージェント数（常時表示）
    running = count_running_agents(data.get('transcript_path'))
    parts.append(f'agent: {running}')

    # コンテキスト
    pct = int(data.get('context_window', {}).get('used_percentage', 0) or 0)
    parts.append(fmt_bar('ctx', pct))

    # レート制限（Pro/Maxプランのみ表示）
    five = data.get('rate_limits', {}).get('five_hour', {}).get('used_percentage')
    if five is not None:
        parts.append(fmt_bar('5h', five))
    week = data.get('rate_limits', {}).get('seven_day', {}).get('used_percentage')
    if week is not None:
        parts.append(fmt_bar('7d', week))

    # コスト
    cost = data.get('cost', {}).get('total_cost_usd', 0) or 0
    parts.append(f'cost ${cost:.3f}')

    # 経過時間
    dur_ms = data.get('cost', {}).get('total_duration_ms', 0) or 0
    mins = int(dur_ms // 60000)
    secs = int((dur_ms % 60000) // 1000)
    parts.append(f'elapsed {mins}m{secs}s')

    print(f'{DIM}│{R}'.join(f' {p} ' for p in parts), end='')

except Exception:
    sys.exit(0)
