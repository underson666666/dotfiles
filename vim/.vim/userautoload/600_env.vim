" Windows Subsystem for Linux で、ヤンクでクリップボードにコピー
" if executable("clip.exe")
"   augroup myYank
"     autocmd!
"     autocmd TextYankPost * :call system('clip.exe', @")
"   augroup END
" endif
" if has('win32')
"   set clipboard=unnamedplus,unnamed,autoselect
" endif

" WSLでページスクロールした際に背景色がおかしくなる現象の対応
" [WSL + tmux + vim で背景色がおかしくなることについて． - Qiita](https://qiita.com/physics303/items/a4d3340ddfdf820e6a33)
set t_ut=""

" tmux使用時にカラースキーマが反映されるように
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" terminalにGuakeを使っているときに背景を透過できるように
if executable("guake")
  function! s:TransparentTerminal() abort
    highlight Normal ctermbg=NONE guibg=NONE
    highlight NonText ctermbg=NONE guibg=NONE
    highlight SpecialKey ctermbg=NONE guibg=NONE
    highlight EndOfBuffer ctermbg=NONE guibg=NONE
    set nocursorline
  endfunction

  augroup transparentTerminal
    autocmd!
    autocmd VimEnter,Colorscheme * call s:TransparentTerminal()
  augroup End
endif
