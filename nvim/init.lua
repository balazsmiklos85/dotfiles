require('config.lazy')
require('config.mason')
require('config.lspconfig')
require('config.dap-ui')
require('config.telescope')
require('config.catppuccin')

if os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY") then
  vim.cmd[[colorscheme catppuccin-frappe]]
else
  local wifi = ""
  if io.popen("uname"):read("*l") == "Darwin" then
    local handle = io.popen("networksetup -getairportnetwork en0")
    wifi = handle:read("*a")
    handle:close()
  end

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

