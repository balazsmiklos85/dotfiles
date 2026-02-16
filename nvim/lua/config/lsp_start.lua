vim.lsp.config('groovyls', {
  cmd = { "groovy-language-server" },
  filetypes = { "gradle", "groovy" },
})

vim.lsp.enable('groovyls')

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

vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local client_count = -1
		if vim.version().minor < 10 then
			client_count = #vim.lsp.get_active_clients()
		else
			client_count = #vim.lsp.get_clients()
		end
		if client_count == 0 then
			vim.cmd("LspStart")
		end
	end,
})
