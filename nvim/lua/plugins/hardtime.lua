if vim.version().minor < 10 then
	return {}
end

return {
	"m4xshen/hardtime.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim"
	},
	opts = {}
}
