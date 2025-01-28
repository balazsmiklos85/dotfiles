return {
	"tris203/precognition.nvim",
	event = "VeryLazy",
	opts = {
		cond = function()
			local current_directory = vim.fn.getcwd()
			for _, directory in ipairs({
				"leetcode",
			}) do
				if current_directory:find(directory, 1, true) then
					return false
				end
			end
			return true
		end,

		startVisible = true,
		showBlankVirtLine = true,
		highlightColor = { link = "Comment" },
		hints = {
			Caret = { text = "^", prio = 2 },
			Dollar = { text = "$", prio = 1 },
			MatchingPair = { text = "%", prio = 5 },
			Zero = { text = "0", prio = 1 },
			w = { text = "w", prio = 10 },
			b = { text = "b", prio = 9 },
			e = { text = "e", prio = 8 },
			W = { text = "W", prio = 7 },
			B = { text = "B", prio = 6 },
			E = { text = "E", prio = 5 },
		},
		gutterHints = {
			G = { text = "G", prio = 10 },
			gg = { text = "gg", prio = 9 },
			PrevParagraph = { text = "{", prio = 8 },
			NextParagraph = { text = "}", prio = 8 },
		},
		disabled_fts = {
			"startify",
		},
	},
}
