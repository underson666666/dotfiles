" This use plugin manager, [Vim-Plug](https://github.com/junegunn/vim-plug)
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/autoload')
" Declare the list of plugins.

  " カラーテーマ
  Plug 'tomasr/molokai'
  Plug 'haishanh/night-owl.vim'
  Plug 'tomasiser/vim-code-dark'
  Plug 'cormacrelf/vim-colors-github'
  Plug 'yasukotelin/shirotelin'
  Plug 'sainnhe/edge'
  Plug 'sainnhe/everforest'
  Plug 'cocopon/iceberg.vim'
  Plug 'underson666666/color-scheme-switcher-over-time'

  " filetype
  " plantuml syntax
  " Plug 'aklt/plantuml-syntax'
  " Ansible syntax
  " Plug 'pearofducks/ansible-vim', { 'for': 'ansible' }
  " CSVを見やすくする
  Plug 'mechatroner/rainbow_csv'
  " 各言語のテンプレート
  Plug 'mattn/vim-sonictemplate'
  " HTML入力効率化
  Plug 'mattn/emmet-vim'
  " 自動でHTMLタグを閉じる
  Plug 'alvan/vim-closetag'
  " ファイルタイプに応じたコメントアウト
  Plug 'tyru/caw.vim'
  " 非同期な各言語でリント実行ツール
  Plug 'dense-analysis/ale'

  " Git関連
  Plug 'airblade/vim-gitgutter'
  Plug 'lambdalisue/gina.vim'

  " ファイルツリー
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'

  " Language Server
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'mattn/vim-lsp-icons'

  " search/replace
  " ファイル検索
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'mattn/ctrlp-matchfuzzy'
  " 複数の文字列を検索してハイライト
  Plug 't9md/vim-quickhl'
  " カーソル行の移動候補文字をハイライト
  Plug 'unblevable/quick-scope'
  " 選択範囲の文字列を検索
  Plug 'thinca/vim-visualstar'
  " grep結果などを一括置換 :Qfreplace
  Plug 'thinca/vim-qfreplace'

  " statusline
  Plug 'itchyny/lightline.vim'
  Plug 'itchyny/vim-gitbranch'

  " misc
  " windowのリサイズ
  Plug 'simeji/winresizer'
  " undo tree
  Plug 'mbbill/undotree'
  " 自作チートシートを開く :Cheat
  Plug 'reireias/vim-cheatsheet'
  " バッファにあるファイルをシュッっと実行
  Plug 'thinca/vim-quickrun'
  " 括弧で囲ったり囲っている文字を変更
  Plug 'tpope/vim-surround'
  " テーブル整形
  Plug 'dhruvasagar/vim-table-mode'
  " テキストオブジェクトの強化
  Plug 'wellle/targets.vim'
  " 自動で括弧を閉じる
  "Plug 'mattn/vim-lexiv'   " このプラグインはバグがあった2020/09/10
  Plug 'jiangmiao/auto-pairs'
  " indent guide
  Plug 'nathanaelkane/vim-indent-guides'

  Plug 'tyru/open-browser.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()
