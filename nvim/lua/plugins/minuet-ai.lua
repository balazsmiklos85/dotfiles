if require("util.functions").is_macos() then
	return {}
end

return {
	"milanglacier/minuet-ai.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("minuet").setup({
			provider = "openai_compatible",
			n_completions = 1,
			context_window = 32768,
			cmp = {
				enable_auto_complete = true,
			},
			provider_options = {
				openai_compatible = {
					end_point = "http://localhost:1234/v1/chat/completions",
					name = "LMStudio",
					model = "zeta",
					api_key = function ()
						return "dummy-key"
					end,
					stream = true,
					optional = {
						temperature = 0.1,
						max_tokens = 4096,
					},
				},
			},
		})
	end,
}
