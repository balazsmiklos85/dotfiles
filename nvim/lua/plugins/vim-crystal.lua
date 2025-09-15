return {
	"vim-crystal/vim-crystal",
	cond = function()
		return vim.fn.executable("crystal") == 1
	end,
}
