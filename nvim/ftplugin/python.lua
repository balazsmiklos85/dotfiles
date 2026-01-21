vim.lsp.config.pylsp = {
  cmd = { "pylsp" },
  filetypes = { "python" }
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function(args)
		vim.lsp.enable("pylsp", { bufnr = args.buf })
	end,
})
