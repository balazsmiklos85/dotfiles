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
			java = { "google-java-format" },
			json = { "jsonnetfmt" },
			lua = { "stylua" },

			yaml = { "yamlfmt" },
		},
	},
}
