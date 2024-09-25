vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

vim.cmd([[set linebreak]])
vim.cmd([[set conceallevel=1]])
vim.cmd([[set number]])
vim.cmd([[set list]])
vim.cmd([[set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣]])

require("config.lazy")
require("config.mason")
require("config.keymaps")
require("config.relative_numbers")

vim.cmd([[colorscheme catppuccin]])

