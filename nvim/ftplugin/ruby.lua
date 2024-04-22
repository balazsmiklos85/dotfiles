vim.cmd 'setlocal shiftwidth=2 smarttab'
vim.cmd 'setlocal expandtab'

local lspconfig = require('lspconfig')
lspconfig.ruby_lsp.setup{}
lspconfig.solargraph.setup{}

