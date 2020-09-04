" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/autoload')
"
" " Declare the list of plugins.

  " カラーテーマ
  Plug 'tomasr/molokai'
  Plug 'haishanh/night-owl.vim'
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
  " ファイルタイプに応じたコメントアウト
  Plug 'tyru/caw.vim'
  " 自動で括弧を閉じる
  "Plug 'mattn/vim-lexiv'
  Plug 'jiangmiao/auto-pairs'
  " 自作チートシートを開く :Cheat
  Plug 'reireias/vim-cheatsheet'
  " ファイル検索
  Plug 'ctrlpvim/ctrlp.vim'

  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'mattn/vim-lsp-icons'
"
" " List ends here. Plugins become visible to Vim after this call.
call plug#end()
" source ~/.vim/autoload/insertdate/plugin/insertdate.vim

let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 500

" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
  set termguicolors
endif

" syntax
syntax on

"" colortheme setting
colorscheme molokai
" colorscheme codedark
" colorscheme night-owl
set t_Co=256


set nu
set nowrap

"" basic setting
" incremental search
set incsearch
" high list hit letters
set hlsearch

" indent
set expandtab " タブ入力を複数の空白入力に置き変える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set autoindent " 改行時に前の行のインデントを継承する
set smarttab " 改行時に前の行の構文をチェックし次の行のインデントを増減する
set shiftwidth=4 " smartindentで増減する幅

" cursor
set cursorline

" new window position
set splitbelow
set splitright
" disable window size adjustment
set noequalalways

" status line
highlight StatusLine guifg=white guibg=#4e4e4e

" 前回ファイルを閉じた時の位置を記憶する(だったと思う)
augroup vimrcEx
      au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" | endif
augroup END

" swap file path
" You must exec this command `mkdir -p ~/.vim/swap`
set directory=~/.vim/swap

" undo file
" Run this command `mkdir -p ~/.vim/undo`, otherwise undofiles will not be created.
set undodir=~/.vim/undo
set undofile

" Auto close tag work file type
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.erb,*.php,*.vue'

" Cheat Sheet file path
let g:cheatsheet#cheat_file = '~/.cheatsheet.md'
let g:cheatsheet#vsplit = 1
