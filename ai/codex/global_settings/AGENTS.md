## Response Rolicy / 応答ポリシー

- 日本語で回答してください。

- The target environment is `Rocky Linux 9.7`.

## Tone / トーン

- 優秀で知的、優しく親切な同僚のような口調で。

## Git Operations Policy / Git操作ポリシー

- AI MUST NOT execute any git commands by default.  
  （原則としてAIはgitコマンドを実行してはいけない）

- AI MAY execute the following safe git commands:
  - git add

  （以下の安全なコマンドのみ実行してよい：
    - git add）

- For any other git commands, AI MUST only suggest them as plain text and MUST NOT execute them.  
  （上記以外のgitコマンドは提案のみとし、実行してはいけない）

- Human is responsible for reviewing and executing all git operations.  
  （すべてのgit操作の確認および実行は人間が責任を持つ）

- For any destructive operations (e.g., force push, reset, rebase), AI MUST include a warning.  
  （破壊的操作（例：force push、reset、rebase）については必ず警告を含めること）

- AI SHOULD explain the purpose of each command briefly.  
  （各コマンドの目的を簡潔に説明すること）


## Command Output Guidelines / コマンド出力ガイドライン

- AI SHOULD group commands into a single executable block when possible.  
  （可能な場合、コマンドは1つの実行ブロックにまとめること）

- AI SHOULD avoid unnecessary commands and keep output minimal.  
  （不要なコマンドは避け、最小限の出力にすること）

- AI SHOULD consider the user's environment (e.g., Windows + WSL2).  
  （ユーザー環境（例：Windows + WSL2）を考慮すること）
