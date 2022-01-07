" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
  set termguicolors
endif

"" colortheme setting
if filereadable( expand("$HOME/.vim/autoload/molokai/colors/molokai.vim") )
    " colorscheme molokai
    " colorscheme codedark
    colorscheme night-owl

    " let g:github_colors_soft = 1
    " colorscheme github
    " set bg=light
endif
set t_Co=256

