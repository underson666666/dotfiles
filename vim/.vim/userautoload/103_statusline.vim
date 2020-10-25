" status line
set laststatus=2    " always display statusline
highlight StatusLine guifg=black guibg=#ffffff
set statusline=%f\ %m\ %r\ %w\ %q%=%l/%Lrow\ %ccol\ %P\ [%{(&fenc!=''?&fenc:&enc)}]\ [%{&tabstop}\ spaces]\ [%{&ff}]\ [%{&syntax}]

