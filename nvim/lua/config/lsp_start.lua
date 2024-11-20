vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		local clients = vim.lsp.get_active_clients()
		if #clients == 0 then
			vim.cmd("LspStart")
		end
	end,
})
