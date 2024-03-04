require('lazyvim')
require('treesitter')
require('lsp')

vim.keymap.set('n', '<C-p>', ':Files<CR>')

vim.cmd[[set background=dark]]
vim.cmd[[colorscheme catppuccin]]

vim.cmd[[set number]]
vim.cmd[[set list]]
