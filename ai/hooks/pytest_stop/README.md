# pytest Stopフックの導入

Python 3の標準ライブラリだけでセットアップできます。対象は既存のプロジェクトディレクトリです。
`setup_hooks.py` と `pytest_stop.py` を同じディレクトリに配置して実行してください。
導入元の設定ファイルや `.codex/` ディレクトリは不要です。

```text
配布用ディレクトリ/
├── setup_hooks.py
└── pytest_stop.py
```

同梱の `pytest_stop.py` は配置用のファイルです。導入先では従来どおり
`.codex/hooks/pytest_stop.py` にコピーされ、その場所から実行されます。

```bash
python3 setup_hooks.py install --target /path/to/project --tool both --dry-run
python3 setup_hooks.py install --target /path/to/project --tool both
python3 setup_hooks.py uninstall --target /path/to/project --tool claude --dry-run
python3 setup_hooks.py uninstall --target /path/to/project --tool claude
```

`--tool` は `codex` / `claude` / `both` から選べます。Claude設定はUbuntu/Linux向けの `python3` コマンドです。
pytestは導入先の `.venv` があればそのPythonで実行します。pytestや依存パッケージのインストールは行いません。

## 設定とバックアップ

- Codex: `.codex/hooks.json`
- Claude Code: `.claude/settings.json`
- 共通スクリプト: `.codex/hooks/pytest_stop.py`
- 管理情報: `.codex/hooks/setup-manifest.json`

既存の他のフックや設定を保持して追加します。再実行しても重複登録しません。
更新・削除する既存ファイルは、同じディレクトリの `<ファイル名>.bak-<ランダムID>` にバックアップします。
バックアップには設定が含まれるため、共有・コミットする内容を確認してください。
dry-runではファイル・ディレクトリ・バックアップを作らず、操作予定だけ表示します。

uninstallは管理情報に記録したフックだけを削除します。導入前から同じ設定がある場合は管理外として保持します。
登録後に手動変更されたフック、競合する設定、壊れたJSON、シンボリックリンクは自動上書きしません。
共通スクリプトは、このセットアップで管理しており、内容が未変更で、両ツールの設定から参照されなくなった場合だけ削除します。
状態ログ・無効化ファイル・バックアップは削除しません。管理情報は所有権確認のため残します。

設定を編集中、または別のセットアップ処理を実行中には起動しないでください。
書き込みはファイル単位で置き換えます。複数ファイル全体のトランザクションではないため、途中のI/Oエラーでは一部の変更が残る場合があります。
その場合は表示されたエラーとバックアップを確認してください。

導入後は各ツールでフック設定を確認してください。Claude Codeでは `/hooks` から確認できます。
