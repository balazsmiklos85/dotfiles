local Path = require("plenary.path")

local documents = ""
local current_dir = vim.fn.getcwd()
local ending = "/notes"
if current_dir:sub(-#ending) == ending then
	documents = current_dir
end

return {
	"obsidian-nvim/obsidian.nvim",
	name = "obsidian",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	cond = function ()
		return current_dir == documents
	end,
	opts = {
		workspaces = {
			{
				path = documents,
				name = "notes",
			},
		},
		notes_subdir = "új",
		daily_notes = {
			folder = "personal/health and well-being/mental and emotional health/journaling/" .. os.date("%Y/%m"),
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			template = nil,
		},

		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},

		new_notes_location = "notes_subdir",

		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub('[*"\\/<>:|?]', ""):lower()
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			local pattern = "^%d+%-"
			if not suffix:match(pattern) then
				suffix = tostring(os.time()) .. "-" .. suffix
			end
			return suffix
		end,

		preferred_link_style = "wiki",

		templates = {
			subdir = "sablonok",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			substitutions = {},
		},

		picker = {
			name = "telescope.nvim",
		},

		legacy_commands = false,
	},
}
