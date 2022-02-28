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
