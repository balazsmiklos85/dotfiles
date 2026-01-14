local lsp_opts = {
	on_attach = function(client)
		client.notify({ method = "textDocument/didOpen" })
	end,
	settings = {
		ruby = {
			workspace = {
				root_patterns = {
					".git",
					"Gemfile",
					"Rakefile",
					"Guardfile",
					"Capfile",
					"config.ru",
					"Dockerfile",
				},
			},
		},
	},
}

if vim.fn.has("nvim-0.11") == 1 then
	vim.lsp.config("ruby_lsp", lsp_opts)
	vim.lsp.enable("ruby_lsp")
else
	require("lspconfig").ruby_lsp.setup(lsp_opts)
end

require("dap-ruby").setup()

vim.diagnostic.config({
	float = true,
	jump = {
		float = false,
		wrap = true,
	},
	severity_sort = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	virtual_lines = false,
	virtual_text = true,
})
