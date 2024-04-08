require('config.lazy')
require('config.lspconfig')
require('config.telescope')

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

