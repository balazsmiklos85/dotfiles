vim.g.dbs = {
	-- { name = 'dev', url =  vim.fn.system('get-dev-db'):gsub("%s+", "") },
	{ name = "staging", url = vim.fn.system("get-staging-db"):gsub("%s+", "") },
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "mariadb", "java" },
	callback = function()
		vim.b.db = vim.g.dbs[1].url
		require("cmp").setup.buffer({
			sources = {
				{ name = "vim-dadbod-completion" },
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
			},
		})
	end,
})
