" 100番代 Vim全体に関わる設定
" 200番代 Vim全体に関わるプラグインの設定
" 300番代 ファイルタイプごとの設定
" 400番代 アプリケーション,プラグインの設定
"
"" basic setting
" syntax
syntax on

" 文字コード自動判別
set encoding=utf-8
set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
" set fileencodings=utf-8

" 改行コード自動判別
set fileformats=unix,dos,mac
" set ff=unix " $B2~9T%3!<%I(B dos/mac/unix
" 改行コード可視化
set nolist

" incremental search
set incsearch
" high list hit letters
set hlsearch

set nu
set nowrap

" cursor
set cursorline

" new window position
set splitbelow
set splitright
" disable window size adjustment
set noequalalways

" swap file path
" You must exec this command `mkdir -p ~/.vim/swap`
set directory=~/.vim/swap

" undo file
" Run this command `mkdir -p ~/.vim/undo`, otherwise undofiles will not be created.
set undodir=~/.vim/undo
set undofile


" 前回ファイルを閉じた時の位置を記憶する(だったと思う)
augroup vimrcEx
      au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" | endif
augroup END

