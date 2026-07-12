#!/usr/bin/env python3
import json, sys, os

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

    model = data.get('model', {}).get('display_name', 'Claude')
    parts = [model]

    # ディレクトリ名
    cwd = data.get('workspace', {}).get('current_dir', '')
    if cwd:
        parts.append(os.path.basename(cwd))

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
