vim.lsp.config("groovyls", {
	cmd = { "groovy-language-server" },
	filetypes = { "groovy" },
})

vim.lsp.enable("groovyls")

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})
vim.lsp.enable("lua_ls")

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

