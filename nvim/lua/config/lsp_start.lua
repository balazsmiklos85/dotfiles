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
