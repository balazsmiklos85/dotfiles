local lspconfig = require("lspconfig")

lspconfig.ruby_lsp.setup({
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

lspconfig.solargraph.setup({
	cmd = { "solargraph", "stdio" },
	settings = {
		solargraph = {
			diagnostics = true,
			completion = true,
			definitions = true,
			references = true,
			rename = true,
			symbols = true,
			hover = true,
			formatting = true,
			folding = true,
			useBundler = true,
		},
	},
	root_dir = function(startpath)
		return lspconfig.util.root_pattern(".git", "Gemfile", "Rakefile")(startpath)
	end,
})

lspconfig.sorbet.setup({
	cmd = { "srb", "tc", "--lsp", "--dir=lib", "--disable-watchman" },
	root_dir = function(startpath)
		return lspconfig.util.root_pattern("Gemfile", ".git")(startpath)
	end,
})

require("dap-ruby").setup()
