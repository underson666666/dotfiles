set noshowmode

function! CustomExpand() abort
    return "%{&tabstop}\%{(&expandtab?'sp':'tb')}"
endfunction
function! CustomFf() abort
    let dic_line = {'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR'}
    return "%{dic_line[&ff]}"
endfunction
function! LineCounter() abort
    " 0がerror+style_error, 1がwarning+style_warning と思われる
    return "E:%{ale#statusline#Count(bufnr('%'))['0']}/W:%{ale#statusline#Count(bufnr('%'))['1']}/I:%{ale#statusline#Count(bufnr('%'))['info']}"
endfunction
function! CustomSyntax() abort
    return "%{&syntax}"
endfunction
function! CustomGitBranch() abort
    if !exists(":gitbranch#name()")
        return "%{gitbranch#name()}"
    else
        return ""
    endif
endfunction

let g:lightline = {
    \     'colorscheme': 'edge',
    \     'active': {
    \        'left': [ [ 'mode', 'paste' ],
    \                  [ 'readonly', 'filename', 'modified' ],
    \                  [ 'lineCounter' ],
    \                  [ 'gitBranch' ],
    \                ],
    \        'right': [ [ 'lineinfo' ],
    \                   [ 'percent' ] ,
    \                   [ 'customExpand', 'fileencoding', 'customFf', 'customSyntax' ]
    \                 ],
    \      },
    \      'component': {
    \         'gitBranch': CustomGitBranch(),
    \         'customFf': CustomFf(),
    \         'customExpand': CustomExpand(),
    \         'customSyntax': CustomSyntax(),
    \         'lineCounter': LineCounter(),
    \      },
    \ }
