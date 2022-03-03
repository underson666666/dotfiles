"" basic setting
" syntax
syntax on

" 文字コード自動判別
set encoding=utf-8
" set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileencodings=utf-8

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
set equalalways

set wildmenu

" swap and undo
function! CreateRequiredDirs() abort
    let l:unkos = ["/.vim/", "/.vim/undo", "/.vim/swap"]
    for l:unko in l:unkos
        let l:d =  expand("$HOME") . l:unko
        if isdirectory(l:d) == 0
            call mkdir(l:d)
        endif
    endfor
endfunction
call CreateRequiredDirs()
set directory=~/.vim/swap
set undodir=~/.vim/undo
set undofile


" 前回ファイルを閉じた時の位置を記憶する(だったと思う)
augroup vimrcEx
      au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
        \ exe "normal g`\"" | endif
augroup END

if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    "         " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    "                 " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif
