local lsp_version = nil
if vim.version().minor < 10 then
	lsp_version = 'v1.8.0'
end

return {
	'neovim/nvim-lspconfig',
	version = lsp_version,
}
