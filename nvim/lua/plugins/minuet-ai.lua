local functions = require("util.functions")

if functions.is_macos() then
	return {}
end

local openai_compatible = {
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
}

if functions.is_macos() then
	openai_compatible.end_point = "http://localhost:11434/v1/chat/completions"
	openai_compatible.name = "Ollama"
	openai_compatible.model = "DiamondGotCat/Zeta-4.5"
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
				openai_compatible = openai_compatible,
			},
		})
	end,
}
