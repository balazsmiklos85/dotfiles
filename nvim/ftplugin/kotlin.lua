vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false
vim.opt_local.colorcolumn = "150"
vim.opt_local.textwidth = 150

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

