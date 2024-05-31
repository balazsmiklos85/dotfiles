require('config.lazy')
require('config.mason')
require('config.lspconfig')
require('config.telescope')

vim.cmd[[set background=dark]]

if os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY") then
  vim.cmd[[colorscheme everforest]]
else
  local handle = io.popen("networksetup -getairportnetwork en0")
  local wifi = handle:read("*a")
  handle:close()

  if string.match(wifi, "FN%-BYOD") then
    vim.cmd[[colorscheme catppuccin-latte]]
  else
   vim.cmd[[colorscheme catppuccin]]
  end
end

vim.cmd[[set linebreak]]
vim.cmd[[set conceallevel=1]]
vim.cmd[[set number]]
vim.cmd[[set list]]
vim.cmd[[set cc=80,120]]

