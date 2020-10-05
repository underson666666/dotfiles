" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/autoload')
"
" " Declare the list of plugins.

  " $B%+%i!<%F!<%^(B
  Plug 'tomasr/molokai'
  Plug 'haishanh/night-owl.vim'
  Plug 'tomasiser/vim-code-dark'
  " CSV$B$r8+$d$9$/$9$k(B
  Plug 'mechatroner/rainbow_csv'
  " vim$B$N(Bwindow$B$N%j%5%$%:(B
  Plug 'simeji/winresizer'
  " undo tree
  Plug 'mbbill/undotree'
  " $BF|IU$r%$%s%5!<%H$9$k(B
  Plug 'underson666666/vim-insertdate'
  " $B<+F0$G(BHTML$B%?%0$rJD$8$k(B
  Plug 'alvan/vim-closetag'
  " $B%U%!%$%k%?%$%W$K1~$8$?%3%a%s%H%"%&%H(B
  Plug 'tyru/caw.vim'
  " $B<+F0$G3g8L$rJD$8$k(B
  "Plug 'mattn/vim-lexiv'   " $B$3$N%W%i%0%$%s$O%P%0$,$"$C$?(B2020/09/10
  Plug 'jiangmiao/auto-pairs'
  " $B<+:n%A!<%H%7!<%H$r3+$/(B :Cheat
  Plug 'reireias/vim-cheatsheet'
  " $B%U%!%$%k8!:w(B
  Plug 'ctrlpvim/ctrlp.vim'
  " $B%P%C%U%!$K$"$k%U%!%$%k$r%7%e%C$C$H<B9T(B
  Plug 'thinca/vim-quickrun'

  " Language Server
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'mattn/vim-lsp-icons'
"
" " List ends here. Plugins become visible to Vim after this call.
call plug#end()

