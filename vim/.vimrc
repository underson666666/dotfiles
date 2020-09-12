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
  "Plug 'mattn/vim-lexiv'   " このプラグインはバグがあった2020/09/10
  Plug 'jiangmiao/auto-pairs'
  " 自作チートシートを開く :Cheat
  Plug 'reireias/vim-cheatsheet'
  " ファイル検索
  Plug 'ctrlpvim/ctrlp.vim'

  " Language Server
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'mattn/vim-lsp-icons'
"
" " List ends here. Plugins become visible to Vim after this call.
call plug#end()
" source ~/.vim/autoload/insertdate/plugin/insertdate.vim

" Language Server
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 350

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


"" basic setting
" 文字コード自動判別
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8

" 改行コード自動判別
set fileformats=unix,dos,mac
" 改行コード可視化
set nolist

" incremental search
set incsearch
" high list hit letters
set hlsearch

set nu
set nowrap
set ff=unix " 改行コード dos/mac/unix

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
set laststatus=2    " always show statusline
" highlight StatusLine guifg=white guibg=#4e4e4e
highlight StatusLine guifg=black guibg=#ffffff
set statusline=%f\ %m\ %r\ %w\ %q%=%l/%Lrow\ %ccol\ %P\ [%{(&fenc!=''?&fenc:&enc)}]\ [%{&tabstop}\ spaces]\ [%{&ff}]\ [%{&syntax}]

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

" Automatically open cwindow after run vimgrep
augroup AutoQuickfix
    autocmd!
    autocmd QuickFixCmdPost *grep* cwindow
augroup END

