" WSLでページスクロールした際に背景色がおかしくなる現象の対応
" [WSL + tmux + vim で背景色がおかしくなることについて． - Qiita](https://qiita.com/physics303/items/a4d3340ddfdf820e6a33)
set t_ut=""

" Windows Subsystem for Linux で、ヤンクでクリップボードにコピー
augroup myYank
    autocmd!
    autocmd TextYankPost * :call system('clip.exe', @")
augroup END
