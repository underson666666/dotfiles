if has("autocmd")
  augroup fileTypeIndent
    autocmd!

    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
    autocmd BufNewFile,BufRead *.js setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd BufNewFile,BufRead *.ts setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd BufNewFile,BufRead *.jsx setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    autocmd BufNewFile,BufRead *.yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
    autocmd BufNewFile,BufRead *.yml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    autocmd BufNewFile,BufRead Dockerfile* setfiletype dockerfile
    autocmd BufNewFile,BufRead Dockerfile* setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

    autocmd BufNewFile,BufRead * call s:SetIndentByFiletype()
  augroup END

endif

function s:SetIndentByFiletype() abort
  if &filetype == 'vim'
    setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  endif
endfunction
