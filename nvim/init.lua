local util = require("util.functions")

local is_macos = io.popen("uname"):read("*l") == "Darwin"
local layout_command =
	"defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep -w 'KeyboardLayout Name' | awk '{print $4}' | sed 's/;//'"

vim.g.mapleader = "ű"
if is_macos and string.find(io.popen(layout_command):read("*a"), "ABC") then
	vim.g.mapleader = "\\"
end

require("config.lazy")
require("config.mason")
require("config.lspconfig")
require("config.dap-ui")
require("config.telescope")

if util.is_ssh() then
	vim.cmd([[colorscheme catppuccin-frappe]])
else
	local wifi = ""
	if is_macos then
		local handle = io.popen("networksetup -getairportnetwork en0")
		wifi = handle:read("*a")
		handle:close()
	end

	if string.match(wifi, "FN%-BYOD") then
		vim.cmd([[colorscheme catppuccin-latte]])
	else
		vim.cmd([[colorscheme catppuccin]])
	end
end

vim.cmd([[set linebreak]])
vim.cmd([[set conceallevel=1]])
vim.cmd([[set number]])
vim.cmd([[set list]])
