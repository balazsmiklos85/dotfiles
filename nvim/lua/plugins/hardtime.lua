if vim.version().minor < 10 then
	return {}
end

return {
	"m4xshen/hardtime.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim"
	},
	opts = {
		disabled_keys = {
			["<Up>"] = { "n", "i", "v" },
			["<Down>"] = { "n", "i", "v" },
			["<Left>"] = { "n", "i", "v" },
			["<Right>"] = { "n", "i", "v" },
			["<PageUp>"] = { "n", "i", "v" },
			["<PageDown>"] = { "n", "i", "v" },
			["<Home>"] = { "n", "i", "v" },
			["<End>"] = { "n", "i", "v" },
			["<S-Home>"] = { "n", "i", "v" },
			["<S-End>"] = { "n", "i", "v" },
			["<S-Up>"] = { "n", "i", "v" },
			["<S-Down>"] = { "n", "i", "v" },
			["<S-Left>"] = { "n", "i", "v" },
			["<S-Right>"] = { "n", "i", "v" },
		},
	}
}
