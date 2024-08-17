vim.api.nvim_create_autocmd("ModeChanged", {
	callback = function()
		local mode = vim.fn.mode()
		vim.opt.relativenumber = mode:match("^v") ~= nil
	end,
	group = vim.api.nvim_create_augroup("RelativeNumbersGroup", {}),
})
