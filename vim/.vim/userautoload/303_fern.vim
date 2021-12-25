let g:fern#renderer = 'nerdfont'
noremap <C-n> :Fern . -drawer -stay -keep -toggle -reveal=% -width=35<CR>
" augroup fernStart
"     autocmd!
"     autocmd VimEnter * ++nested Fern . -drawer -stay -keep -toggle -reveal=% -width=35
" augroup END
