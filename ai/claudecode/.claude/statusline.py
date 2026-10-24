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

    def get_git_branch(cwd):
        # .gitを直接読んでブランチ名を判定する（subprocessでgitを呼ばず起動速度を優先）
        try:
            d = os.path.abspath(cwd)
            while True:
                git_path = os.path.join(d, '.git')
                if os.path.exists(git_path):
                    if os.path.isdir(git_path):
                        head_path = os.path.join(git_path, 'HEAD')
                    else:
                        with open(git_path, 'r', encoding='utf-8') as f:
                            content = f.read().strip()
                        if not content.startswith('gitdir:'):
                            return None
                        gitdir = content[len('gitdir:'):].strip()
                        if not os.path.isabs(gitdir):
                            gitdir = os.path.join(d, gitdir)
                        head_path = os.path.join(gitdir, 'HEAD')
                    with open(head_path, 'r', encoding='utf-8') as f:
                        head = f.read().strip()
                    if head.startswith('ref:'):
                        ref = head[len('ref:'):].strip()
                        if ref.startswith('refs/heads/'):
                            return ref[len('refs/heads/'):]
                        return ref
                    return head[:7]
                parent = os.path.dirname(d)
                if parent == d:
                    return None
                d = parent
        except Exception:
            return None

    def scan_transcript(transcript_path):
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
        model = f'{model} {effort}'
    parts = [model]

    running = scan_transcript(data.get('transcript_path'))

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
    parts.append(f'cost: ${cost:.2f}')

    # キャッシュ状況（v2.1.251以降のprompt_cache。最初のAPIレスポンスまでは存在しない）
    pc = data.get('prompt_cache')
    if pc:
        ttl = pc.get('ttl') or '-'
        hit_ratio = pc.get('hit_ratio')
        hit_str = f'{hit_ratio * 100:.1f}%' if hit_ratio is not None else '-'
        # expires_atはepoch秒。直近レスポンスにキャッシュトークンが無いとnull
        expires_at = pc.get('expires_at')
        if expires_at is not None:
            from datetime import datetime
            exp_str = datetime.fromtimestamp(expires_at).strftime('%H:%M:%S')
        else:
            exp_str = 'cold'
        if not pc.get('warm'):
            exp_str = f'{RED}{exp_str}{R}'
        parts.append(f'cache ttl:{ttl} hit:{hit_str} exp:{exp_str}')

    print(f'{DIM}│{R}'.join(f' {p} ' for p in parts))

    # 2行目: 実行中のサブエージェント数 + ディレクトリ名（可変長のため末尾）
    line2 = [f'agent: {running}']
    cwd = data.get('workspace', {}).get('current_dir', '')
    if cwd:
        dname = os.path.basename(cwd)
        branch = get_git_branch(cwd)
        dir_str = f'{dname} ({branch})' if branch else dname
        line2.append(dir_str)
    print(f'{DIM}│{R}'.join(f' {p} ' for p in line2), end='')

except Exception:
    sys.exit(0)
