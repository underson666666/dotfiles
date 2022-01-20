" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
  set termguicolors
endif

"" colortheme setting
" if filereadable( expand("$HOME/.vim/autoload/molokai/colors/molokai.vim") )
    " colorscheme molokai
    " colorscheme codedark
    " colorscheme night-owl

    " let g:github_colors_soft = 1
    " colorscheme github
    " set bg=light
" endif
set t_Co=256

" color_scheme_switcher
let g:color_scheme_switcher#colors = { "0": "night-owl", "08": "github", "17": "github", "18:30": "night-owl"}
let g:color_scheme_switcher#backgruonds = { "0": "dark", "08": "light", "17": "dark", "18:30": "dark"}
let g:color_scheme_switcher#interval = 1000 * 5

if has('vim_starting')
    call color_scheme_switcher#StartColorSchemeSwitcher()
endif
