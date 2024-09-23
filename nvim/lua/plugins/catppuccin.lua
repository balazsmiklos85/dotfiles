local util = require("util.functions")
local flavour = "auto" -- latte, frappe, macchiato, mocha
if util.is_ssh() then
	flavour = "frappe"
end

return {
	"catppuccin/nvim",
	name = "catppuccin",
	opts = {
		flavour = flavour,
		transparent_background = true,

		integrations = {
			bufferline = true,
			diffview = true,
			mason = true,
			neotree = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
		},
	},
}
