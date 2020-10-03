" vim settings file split
runtime! userautoload/basic/*.vim
runtime! userautoload/plugins/*.vim

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/autoload')
"
" " Declare the list of plugins.

  " カラーテーマ
  Plug 'tomasr/molokai'
  Plug 'haishanh/night-owl.vim'
  Plug 'tomasiser/vim-code-dark'
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
  " バッファにあるファイルをシュッっと実行
  Plug 'thinca/vim-quickrun'

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

" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
  set termguicolors
endif

" syntax
syntax on

"" colortheme setting
" colorscheme molokai
colorscheme codedark
" colorscheme night-owl
set t_Co=256


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


