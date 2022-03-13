set noshowmode

function! CustomExpand() abort
    return "%{&tabstop}\%{(&expandtab?'sp':'tb')}"
endfunction
function! CustomFf() abort
    let dic_line = {'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR'}
    return "%{dic_line[&ff]}"
endfunction
function! LineCounter() abort
    return "E:%{ale#statusline#Count(bufnr('%'))['0']}/W:%{ale#statusline#Count(bufnr('%'))['0']}/I:%{ale#statusline#Count(bufnr('%'))['0']}"
endfunction
function! CustomSyntax() abort
    return "%{&syntax}"
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
    "\                   [ 'customExpand', 'fileencoding', 'customFf', 'filetype', 'customSyntax' ]
    \                   [ 'customExpand', 'fileencoding', 'customFf', 'customSyntax' ]
    \                 ],
    \      },
    \      'component': {
    \         'gitBranch': gitbranch#name(),
    \         'customFf': CustomFf(),
    \         'customExpand': CustomExpand(),
    \         'customSyntax': CustomSyntax(),
    \         'lineCounter': LineCounter(),
    \      },
    \ }
