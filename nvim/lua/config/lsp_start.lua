vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*",
	callback = function()
		if #vim.lsp.get_clients() == 0 then
			vim.cmd("LspStart")
		end
	end,
})
