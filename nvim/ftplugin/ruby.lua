local lspconfig = require("lspconfig")
lspconfig.ruby_lsp.setup({})
lspconfig.solargraph.setup({})
lspconfig.sorbet.setup({})
require("dap-ruby").setup()

