filetype plugin on
filetype indent on

if has("autocmd")
    augroup fileTypeIndent
        autocmd!

        autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

        autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
        autocmd BufNewFile,BufRead *.yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

        autocmd BufNewFile,BufRead Dockerfile* setfiletype dockerfile
        autocmd BufNewFile,BufRead Dockerfile* setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

        " setfiletype$B$@$1$3$N%U%!%$%k$G@_Dj$r$7$F!"(B
        " $B%$%s%G%s%H$N@_Dj$O0J2<$N%Q%9$K%U%!%$%k$r:n$C$F(Bsofttabstop$B$J$I$r$=$N%U%!%$%k$K5-:\$7$F$b(Bok
        " ~/.vim/ftplugin/python.vim
        " ~/.vim/ftplugin/dockerfile.vim
    augroup END
endif

" sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtab$B$NN,(B
" autocmd FileType yaml setlocal sw=2 sts=2 ts=2 et
