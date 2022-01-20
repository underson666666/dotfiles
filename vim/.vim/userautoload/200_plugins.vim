" This use plugin manager, [Vim-Plug](https://github.com/junegunn/vim-plug)
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/autoload')
" " Declare the list of plugins.

  " カラーテーマ
  Plug 'tomasr/molokai'
  Plug 'haishanh/night-owl.vim'
  Plug 'tomasiser/vim-code-dark'
  Plug 'cormacrelf/vim-colors-github'
  Plug 'underson666666/color-scheme-switcher-over-time'
  " CSVを見やすくする
  Plug 'mechatroner/rainbow_csv'
  " vimのwindowのリサイズ
  Plug 'simeji/winresizer'
  " undo tree
  Plug 'mbbill/undotree'
  " 日付をインサートする
  Plug 'underson666666/vim-insertdate'
  " 自動でHTMLタグを閉じる
  Plug 'alvan/vim-closetag'
  " HTML入力効率化
  Plug 'mattn/emmet-vim'
  " ファイルタイプに応じたコメントアウト
  Plug 'tyru/caw.vim'
  " 自動で括弧を閉じる
  "Plug 'mattn/vim-lexiv'   " このプラグインはバグがあった2020/09/10
  Plug 'jiangmiao/auto-pairs'
  " 自作チートシートを開く :Cheat
  Plug 'reireias/vim-cheatsheet'
  " ファイル検索
  Plug 'ctrlpvim/ctrlp.vim'
  " バッファにあるファイルをシュッっと実行
  Plug 'thinca/vim-quickrun'
  " 
  Plug 'tpope/vim-surround'
  " テーブル整形
  Plug 'dhruvasagar/vim-table-mode'
  " 複数の文字列を検索してハイライト
  Plug 't9md/vim-quickhl'

  " plantuml syntax
  " Plug 'aklt/plantuml-syntax'
  " Ansible syntax
  " Plug 'pearofducks/ansible-vim'

  " Git関連プラグイン
  Plug 'airblade/vim-gitgutter'

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
"
" " List ends here. Plugins become visible to Vim after this call.
call plug#end()

filetype plugin on
runtime macros/matchit.vim
