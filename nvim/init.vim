"vim-plug plugins
call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-airline/vim-airline' "lean & mean status/tabline for vim that's light as air
Plug 'airblade/vim-gitgutter' "A Vim plugin which shows a git diff in the 'gutter'
Plug 'drewtempelmeyer/palenight.vim' "Soothing color scheme
Plug 'neovim/nvim-lspconfig'
Plug 'mfussenegger/nvim-jdtls'

call plug#end()

set background=dark
colorscheme palenight

set tabstop=4
set number "showing line numbers
set cc=80 "having a right margin in the 80th column
set list "showing whitespaces

lua require('lsp')

