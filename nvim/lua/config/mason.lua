require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = {
    -- Java
    "jdtls",
    -- Lua
    "lua_ls",
    -- Ruby
    "rubocop",
    "ruby_lsp",
    "sorbet",
    "solargraph",
    -- Rust
    "rust_analyzer",
  }
}
require('mason-tool-installer').setup {
  ensure_installed = {
    -- Java
    "java-debug-adapter",
    "java-test",
    -- Lua
    'stylua',
  }
}

