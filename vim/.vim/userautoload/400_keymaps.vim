" Fern
noremap <silent> <C-n> :Fern . -drawer -stay -keep -toggle -reveal=% -width=35<CR>
" augroup fernStart
"   autocmd!
"   autocmd VimEnter * ++nested Fern . -drawer -stay -keep -toggle -reveal=% -width=35
" augroup END

" config t9md/vim-quickhl
nmap <Space>h <Plug>(quickhl-manual-this)
xmap <Space>h <Plug>(quickhl-manual-this)
nmap <Space>H <Plug>(quickhl-manual-reset)
xmap <Space>H <Plug>(quickhl-manual-reset)

" keymap with LSP
noremap <C-l>h :LspHover<CR>
noremap <C-l>d :LspDefinition<CR>

" dense-analysis/ale
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

noremap S :source ~/.vimrc<CR>


" カーソル下のパスをWindowsエクスプローラーで開く関数
function! OpenExplorerUnderCursor()
  let path = expand("<cfile>")
  if isdirectory(path)
    " パスがディレクトリの場合は直接そのディレクトリを開く
    silent exe "!start explorer /e," . shellescape(path, 1)
  else
  " ファイルの場合はファイルを選択した状態でエクスプローラーを開く
    silent exe "!start explorer /select," . shellescape(path, 1)
  endif
  redraw!
endfunction

" キーマッピング（例：\eで起動）
nnoremap <Leader>e :call OpenExplorerUnderCursor()<CR>

nnoremap ,, :up<CR>
nnoremap ^ ^:up<CR>
