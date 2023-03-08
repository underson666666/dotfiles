" basic setting
syntax on
filetype plugin on
filetype indent on
runtime macros/matchit.vim

" 文字コード自動判別
set encoding=utf-8
" set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fileencodings=utf-8
" 改行コード自動判別
" set fileformats=unix,dos,mac
set nolist
set incsearch
set hlsearch
set nu
set nowrap
set cursorline
set splitbelow
set splitright
set equalalways
set wildmenu

" swap and undo
function! CreateRequiredDirs() abort
  let l:unkos = ["/.vim/", "/.vim/undo", "/.vim/swap"]
  for l:unko in l:unkos
    let l:d =  expand("$HOME") . l:unko
    if isdirectory(l:d) == 0
      call mkdir(l:d)
    endif
  endfor
endfunction
call CreateRequiredDirs()
set directory=~/.vim/swap
set undodir=~/.vim/undo
set undofile

" 前回ファイルを閉じた時の位置を記憶する(だったと思う)
augroup vimrcEx
  au BufRead * if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal g`\"" | endif
augroup END

if has('vim_starting')
  " 挿入モード時に非点滅の縦棒タイプのカーソル
  let &t_SI .= "\e[6 q"
  " ノーマルモード時に非点滅のブロックタイプのカーソル
  let &t_EI .= "\e[2 q"
  " 置換モード時に非点滅の下線タイプのカーソル
  let &t_SR .= "\e[4 q"
endif

set grepprg=grep\ -rn\ --exclude-dir={vender,__pycache__,WEB-INF,classes,lib,target,node_modules,build,venv,.venv,.git}
" Automatically open cwindow after run vimgrep
augroup AutoQuickfix
  autocmd!
  autocmd QuickFixCmdPost *grep* cwindow
augroup END

" defualt indent
set expandtab " タブ入力を複数の空白入力に置き変える
set tabstop=4 " 画面上でタブ文字が占める幅
set softtabstop=4 " 連続した空白に対してタブキーやバックスペースキーでカーソルが動く幅
set shiftwidth=4 " smartindentで増減する幅
set autoindent " 改行時に前の行のインデントを継承する
set smarttab " 改行時に前の行の構文をチェックし次の行のインデントを増減する

set laststatus=2  " always display statusline
" default statusline settings. This will be overwrite in file number 300.
highlight StatusLine guifg=black guibg=#ffffff
let dic_line = {'dos': 'CRLF', 'unix': 'LF', 'mac': 'CR'}
set statusline=%f\ %m\ %r\ %w\ %q
set statusline+=%=
set statusline+=%l/%Lrow\ %ccol\ \|\ %{&fenc}\ \|\ %{dic_line[&ff]}\ \|\ %{&tabstop}\%{(&expandtab?'sp':'tb')}\ \|\ %{&syntax}
set statusline+=\ \|\ E:%{ale#statusline#Count(bufnr('%'))['0']}/W:%{ale#statusline#Count(bufnr('%'))['0']}/I:%{ale#statusline#Count(bufnr('%'))['0']}

" 検索時にヒット数を表示する
if has('patch-8.1.1270')
  set shortmess-=S
endif

" If you have vim >=8.0 or Neovim >= 0.1.5
if (has("termguicolors"))
  set termguicolors
endif
set t_Co=256
