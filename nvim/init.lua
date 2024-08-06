local util = require("util.functions")

vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

require("config.lazy")
require("config.mason")
require("config.lspconfig")
require("config.dap-ui")
require("config.telescope")

if util.is_ssh() then
	vim.cmd([[colorscheme catppuccin-frappe]])
else
	local wifi = ""
	if util.is_macos() then
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
