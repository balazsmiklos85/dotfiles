require('lazy_config')
require('lsp_config')

require('bufferline_config')
require('lualine_config')
require('neo-tree_config')
require('obsidian_config')
require('telescope_config')
require('treesitter_config')

vim.cmd[[set background=dark]]

if os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY") then
  vim.cmd[[colorscheme everforest]]
else
    vim.cmd[[colorscheme catppuccin]]
end

vim.cmd[[set linebreak]]
vim.cmd[[set conceallevel=1]]
vim.cmd[[set number]]
vim.cmd[[set list]]
vim.cmd[[set cc=80,120]]

