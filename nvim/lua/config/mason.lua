require('mason').setup {
  ensure_installed = {
    "groovy-language-server",
    "sonarlint-language-server",
  }
}
require('mason-lspconfig').setup {
  ensure_installed = {
    "jdtls",
    "lua_ls",
    "rubocop",
    "ruby_ls",
    "sorbet",
    "solargraph",
    "rust_analyzer",
  }
}
