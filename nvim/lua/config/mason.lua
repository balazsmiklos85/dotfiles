require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {
    "jdtls",
    "lua_ls",
    "rubocop",
    "ruby_lsp",
    "sorbet",
    "solargraph",
    "rust_analyzer",
  }
}
require('mason-tool-installer').setup {
  ensure_installed = {
    "groovy-language-server",
    "sonarlint-language-server",
  }
}

