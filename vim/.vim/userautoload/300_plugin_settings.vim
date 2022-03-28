" Cheat Sheet file path
let g:cheatsheet#cheat_file = '~/.cheatsheet.md'
let g:cheatsheet#vsplit = 1

" [Github  dhruvasagar/vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
let g:table_mode_corner='|'

" Auto close tag work file type
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.erb,*.php,*.vue'

let g:fern#renderer = 'nerdfont'

" colorscheme
let g:everforest_background = 'hard'
" color_scheme_switcher
let g:color_scheme_switcher#colors = { "0": "night-owl", "08": "everforest", "17": "github", "18:30": "night-owl"}
let g:color_scheme_switcher#backgruonds = { "0": "dark", "08": "light", "17": "dark", "18:30": "dark"}
if has('vim_starting')
    call color_scheme_switcher#StartColorSchemeSwitcher()
endif

" Language Server
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_auto_completeopt = 1
let g:asyncomplete_popup_delay = 500
let g:lsp_log_verbose = 0

" lightline
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

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](node_modules|target|dist)|(\.(DS_Storegit|git|hg|svn|optimized|compiled))$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

