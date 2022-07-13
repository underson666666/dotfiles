if has("autocmd")
  augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead * call s:SetIndentByFiletype()
  augroup END
endif

let s:indent2space = ['javascript', 'vim', 'typescript', 'css', 'yaml']
let s:indent4space = ['python', 'dockerfile']
let s:indent2tab = []
let s:indent4tab = []
function s:SetIndentByFiletype() abort
  if match(s:indent2space, &filetype) != -1
    setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  elseif match(s:indent4space, &filetype) != -1
    setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
  elseif match(s:indent2tab, &filetype) != -1
    setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
  elseif match(s:indent4tab, &filetype) != -1
    setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
  endif
endfunction
