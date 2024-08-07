vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

require("config.lazy")
require("config.mason")
require("config.lspconfig")
require("config.dap-ui")
require("config.telescope")

vim.cmd([[colorscheme catppuccin]])
vim.cmd([[set linebreak]])
vim.cmd([[set conceallevel=1]])
vim.cmd([[set number]])
vim.cmd([[set list]])
