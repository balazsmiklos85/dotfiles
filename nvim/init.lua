local is_ssh = os.getenv("SSH_CLIENT") or os.getenv("SSH_TTY")
local is_macos = io.popen("uname"):read("*l") == "Darwin"
local layout_command = "defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep -w 'KeyboardLayout Name' | awk '{print $3}' | sed 's/;//'"

local leader = 'ű'
if is_macos and io.popen(layout_command):read('*a') == 'ABC' then
  leader = '\\'
end
vim.g.mapleader = leader

require('config.lazy')
require('config.mason')
require('config.lspconfig')
require('config.dap-ui')
require('config.telescope')
require('config.catppuccin')

if is_ssh then
  vim.cmd[[colorscheme catppuccin-frappe]]
else
  local wifi = ""
  if is_macos then
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

