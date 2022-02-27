" status line
set laststatus=2    " always display statusline
highlight StatusLine guifg=black guibg=#ffffff
let dic_line = {'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR'}

set statusline=%f\ %m\ %r\ %w\ %q%=%l/%Lrow\ %ccol\ %P\ \|\ %{&enc}\ \|\ %{&fenc}\ \|\ %{dic_line[&ff]}\ \|\ %{&tabstop}\%{(&expandtab?'sp':'tb')}\ \|\ %{&syntax}
