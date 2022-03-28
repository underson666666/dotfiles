" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
  set termguicolors
endif
set t_Co=256

" Windows Subsystem for Linux で、ヤンクでクリップボードにコピー
if has("wsl")
    augroup myYank
        autocmd!
        autocmd TextYankPost * :call system('clip.exe', @")
    augroup END
endif

" WSLでページスクロールした際に背景色がおかしくなる現象の対応
" [WSL + tmux + vim で背景色がおかしくなることについて． - Qiita](https://qiita.com/physics303/items/a4d3340ddfdf820e6a33)
set t_ut=""

" tmux使用時にカラースキーマが反映されるように
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

