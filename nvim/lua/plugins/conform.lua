return {
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format()
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	opts = {
		formatters_by_ft = {
			css = { "prettier" },
			fish = { "fish_indent" },
			html = { "prettier" },
			java = { "google-java-format" },
			javascript = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			yaml = { "prettier" },
		},
	},
}
