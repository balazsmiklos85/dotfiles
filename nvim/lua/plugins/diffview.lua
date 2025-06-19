return {
	"sindrets/diffview.nvim",
	cond = function()
		local result = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
		return string.find(result, "true")
	end,
}
