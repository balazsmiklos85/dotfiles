local mason_version = nil
local mason_lsp_version = nil
if vim.version().minor < 10 then
  mason_version = 'v1.11.0'
  mason_lsp_version = 'v1.32.0'
end

return {
  {
    'williamboman/mason.nvim',
    version = mason_version,
  },
  {
    'williamboman/mason-lspconfig.nvim',
	version = mason_lsp_version,
    requires = {
      'neovim/nvim-lspconfig',
      'williamboman/mason.nvim',
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    requires = {
      'williamboman/mason.nvim',
    },
  },
}

