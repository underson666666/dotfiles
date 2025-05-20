# vim-screenshot プラグイン

このプラグインは、Windows環境のgVimで、クリップボードにコピーされた画像をファイルとして保存し、そのパスを編集中のドキュメントに挿入する機能を提供します。

## 機能

- クリップボードの画像を自動的にファイルとして保存
- 保存した画像へのパスをカーソルの下の行に挿入
- マークダウンフォーマット（`![Screenshot](パス)`）または単純なパス表示をサポート
- 画像の保存先、ファイル形式、プレフィックスをカスタマイズ可能
- 便利なキーマッピングを提供

## インストール

### 手動インストール

1. `vim-screenshot.vim` ファイルを `~/vimfiles/plugin/` ディレクトリ（Windows）または `~/.vim/plugin/` ディレクトリ（UNIX系）に配置します。

### Vim-Plugを使用する場合

```vim
Plug '（GitHubのユーザー名）/vim-screenshot'
```

## 必要条件

- Windows環境（PowerShellを使用するため）
- gVim

## 設定

`.vimrc` または `_vimrc` に以下の設定を追加することで、プラグインの動作をカスタマイズできます：

```vim
" スクリーンショットの保存先（デフォルト: ~/Documents/VimScreenshots）
let g:screenshot_save_path = '~/Documents/VimScreenshots'

" 画像のファイル形式（デフォルト: png）
let g:screenshot_format = 'png'

" ファイル名のプレフィックス（デフォルト: screenshot）
let g:screenshot_prefix = 'screenshot'

" マークダウン形式で挿入する場合は1、単純なパスなら0（デフォルト: 1）
let g:screenshot_markdown = 1
```

## 使用方法

1. スクリーンショットを撮影し、クリップボードにコピーします（Windows では `Win+Shift+S` キーなど）
2. Vimで以下のいずれかの方法で実行します：
   - ノーマルモードで `\ps` を押します（デフォルトのリーダーキーが `\` の場合）
   - 挿入モードで `Ctrl+G` の後に `Ctrl+P` を押します
3. クリップボードの画像が自動的に保存され、そのパスがカーソルの下の行に挿入されます

## カスタムキーマッピング

デフォルトのキーマッピングを無効にして、独自のキーマッピングを設定することもできます：

```vim
" デフォルトのキーマッピングを無効化
let g:screenshot_no_mappings = 1

" 独自のキーマッピングを設定
nnoremap <F12> :PasteScreenshot<CR>
inoremap <F12> <C-o>:PasteScreenshot<CR>
```

## 動作の仕組み

このプラグインは、以下のように動作します：

1. PowerShellを使用してクリップボードから画像を取得
2. 設定されたディレクトリにタイムスタンプ付きのファイル名で保存
3. 画像へのパスを指定されたフォーマットでカーソルの下の行に挿入

## トラブルシューティング

- クリップボードに画像がない場合は、エラーメッセージが表示されます
- 保存先ディレクトリが存在しない場合は、自動的に作成されます
- Windowsのセキュリティ設定によっては、PowerShellスクリプトの実行が制限されている場合があります。その場合は、PowerShellの実行ポリシーを適切に設定してください

## ライセンス

MITライセンス

## 作者

underson666666

---

このREADMEは、vim-screenshotプラグインの基本的な使用方法と設定について説明しています。プラグインを公開する際は、GitHubリポジトリなどの情報を適宜追加してください。