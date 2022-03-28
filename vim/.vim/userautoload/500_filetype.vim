if has("autocmd")
    augroup fileTypeIndent
        autocmd!

        autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

        autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
        autocmd BufNewFile,BufRead *.yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

        autocmd BufNewFile,BufRead Dockerfile* setfiletype dockerfile
        autocmd BufNewFile,BufRead Dockerfile* setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

    augroup END
endif

let g:ale_fixers = {
    \ 'python': ['black'],
    \ }
