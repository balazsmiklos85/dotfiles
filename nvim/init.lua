vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.cmd([[set linebreak]])
vim.cmd([[set conceallevel=1]])
vim.cmd([[set number]])
vim.cmd([[set list]])
vim.cmd([[autocmd FileType mail setlocal textwidth=0]])
vim.opt_local.colorcolumn = "120"
vim.opt_local.textwidth = 120

require("config.lazy")
require("config.mason")
require("config.keymaps")
require("config.relative_numbers")
require("config.lsp_start")

if require("util.functions").is_at_work() then
	vim.cmd([[colorscheme catppuccin-latte]])
else
	vim.cmd([[colorscheme catppuccin-mocha]])
end
-- keeping the colors of the terminal, preserving opacity:
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
