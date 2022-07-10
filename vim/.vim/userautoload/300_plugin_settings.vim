" Cheat Sheet file path
let g:cheatsheet#cheat_file = '~/.cheatsheet.md'
let g:cheatsheet#vsplit = 1

" [Github  dhruvasagar/vim-table-mode](https://github.com/dhruvasagar/vim-table-mode)
let g:table_mode_corner='|'

" Auto close tag work file type
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.erb,*.php,*.vue,*.jsx,*.tsx'

let g:fern#renderer = 'nerdfont'

" colorscheme
let g:everforest_background = 'hard'
" color_scheme_switcher
let g:color_scheme_switcher#colors = { "0": "night-owl", "08": "everforest", "17": "github", "18:30": "night-owl"}
let g:color_scheme_switcher#backgruonds = { "0": "dark", "08": "light", "17": "dark", "18:30": "dark"}
if has('vim_starting')
  try
    call color_scheme_switcher#StartColorSchemeSwitcher()
  catch
  endtry
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
  return winwidth(0) > 90 ? &tabstop.(&expandtab?'sp':'tb') : ''
endfunction
function! CustomFf() abort
  let dic_line = {'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR'}
  return winwidth(0) > 80 ? dic_line[&ff] : ''
endfunction
function! LintCounter() abort
  " 0がerror+style_error, 1がwarning+style_warning と思われる
  return winwidth(0) > 70 ? 'E:'.ale#statusline#Count(bufnr('%'))['0'].'/W:'.ale#statusline#Count(bufnr('%'))['1']."/I:".ale#statusline#Count(bufnr('%'))['info'] : ''
endfunction
function! CustomSyntax() abort
  return &syntax
endfunction
function! CustomGitBranch() abort
  if !exists(":gitbranch#name()")
    return winwidth(0) > 90 ? gitbranch#name() : ''
  else
    return ""
  endif
endfunction

let g:lightline = {
  \   'colorscheme': 'edge',
  \   'active': {
  \     'left': [ [ 'mode', 'paste' ],
  \       [ 'readonly', 'filename', 'modified' ],
  \       [ 'lintCounter' ],
  \       [ 'gitBranch' ],
  \     ],
  \     'right': [ [ 'lineinfo' ],
  \       [ 'percent' ] ,
  \       [ 'customExpand', 'fileencoding', 'customFf', 'customSyntax' ]
  \     ],
  \   },
  \   'component_function': {
  \     'gitBranch': 'CustomGitBranch',
  \     'customFf': 'CustomFf',
  \     'customExpand': 'CustomExpand',
  \     'customSyntax': 'CustomSyntax',
  \     'lintCounter': 'LintCounter',
  \   },
  \ }

let s:ignore_dir = 'node_modules\|target\|dist\|data\|__pycache__\|classes\|libs\|log\|logs'
let g:ctrlp_custom_ignore = {
  \ 'dir':  s:ignore_dir,
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

let g:ale_linters = {
  \   'javascript': ['eslint'],
  \ }
let g:ale_fixers = {
  \   'javascript': ['prettier'],
  \   'python': ['autopep8', 'black', 'isort'],
  \   'go': ['gofmt'],
  \ }
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_javascript_prettier_options = '--single-quote --no-semi --tab-width 2 --no-bracket-spacing --end-of-line auto'

" indent guides
" let g:indent_guides_enable_on_vim_startup = 1

let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
