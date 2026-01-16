vim.lsp.config("ruby_lsp", {
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
})
vim.lsp.enable("ruby_lsp")

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
