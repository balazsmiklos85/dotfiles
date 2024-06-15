require('mason').setup()
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

