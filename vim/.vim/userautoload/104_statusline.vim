" status line
set laststatus=2    " always display statusline
highlight StatusLine guifg=black guibg=#ffffff
let dic_line = {'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR'}

set statusline=%f\ %m\ %r\ %w\ %q
set statusline+=%=
set statusline+=%l/%Lrow\ %ccol\ \|\ %{&fenc}\ \|\ %{dic_line[&ff]}\ \|\ %{&tabstop}\%{(&expandtab?'sp':'tb')}\ \|\ %{&syntax}
set statusline+=\ \|\ E:%{ale#statusline#Count(bufnr('%'))['0']}/W:%{ale#statusline#Count(bufnr('%'))['0']}/I:%{ale#statusline#Count(bufnr('%'))['0']}
