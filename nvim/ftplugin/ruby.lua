require("dap-ruby").setup()

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

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
