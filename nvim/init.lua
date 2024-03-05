require('lazyvim')
require('treesitter')
require('lsp')

vim.keymap.set('n', '<C-p>', ':Files<CR>')

vim.cmd[[set background=dark]]
if vim.fn.match(vim.env.TERM, 'xterm') >= 0 then
    vim.cmd[[colorscheme palenight]]
else
    vim.cmd[[colorscheme catppuccin]]
end

vim.cmd[[set number]]
vim.cmd[[set list]]
