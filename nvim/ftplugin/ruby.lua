local lspconfig = require("lspconfig")
lspconfig.ruby_lsp.setup({})
lspconfig.solargraph.setup({})
require("dap-ruby").setup()

