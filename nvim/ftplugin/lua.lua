local lsp_opts = {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
}

if vim.fn.has("nvim-0.11") == 1 then
	vim.lsp.config("lua_ls", lsp_opts)
	vim.lsp.enable("lua_ls")
else
	require("lspconfig").lua_ls.setup(lsp_opts)
end
