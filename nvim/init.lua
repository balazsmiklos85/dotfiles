require('lazy_config')
require('lsp_config')

require('bufferline_config')
require('lualine_config')
require('neo-tree_config')
require('telescope_config')
require('treesitter_config')

vim.cmd[[set background=dark]]

if io.popen("uname"):read("*l") == 'Linux' and not (os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")) then
    vim.cmd[[colorscheme catppuccin]]
else
    vim.cmd[[colorscheme palenight]]
end

vim.cmd[[set number]]
vim.cmd[[set list]]
vim.cmd[[set cc=80,120]]

