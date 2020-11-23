" status line
set laststatus=2    " always display statusline
highlight StatusLine guifg=black guibg=#ffffff
let dic_line = {'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR'}
if has_key(dic_line, &ff)
    let repfileformat = dic_line[&ff]
else
    let repfileformat = 'unknown'
endif

set statusline=%f\ %m\ %r\ %w\ %q%=%l/%Lrow\ %ccol\ %P\ [%{(&fenc!=''?&fenc:&enc)}]\ [%{&tabstop}\ spaces]\ [%{repfileformat}]\ [%{&syntax}]
