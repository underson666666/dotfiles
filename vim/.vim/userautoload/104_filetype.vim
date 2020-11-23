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

        " setfiletypeだけこのファイルで設定をして、
        " インデントの設定は以下のパスにファイルを作ってsofttabstopなどをそのファイルに記載してもok
        " ~/.vim/ftplugin/python.vim
        " ~/.vim/ftplugin/dockerfile.vim
    augroup END
endif

" sw=softtabstop, sts=shiftwidth, ts=tabstop, et=expandtabの略
" autocmd FileType yaml setlocal sw=2 sts=2 ts=2 et
