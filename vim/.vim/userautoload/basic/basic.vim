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
set ff=unix " $B2~9T%3!<%I(B dos/mac/unix

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


