return {
	"Isrothy/neominimap.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	init = function()
		vim.opt.wrap = false
		vim.opt.sidescrolloff = 36
		vim.g.neominimap = {
			auto_enable = true,
		}
	end,
}
