local opts = {
	enable_git_status = true,
	close_if_last_window = true,
	auto_clean_after_session_restore = true,
	filesystem = {
		follow_current_file = {
			enabled = true,
		},
		hijack_netrw_behavior = "open_current",
		use_libuv_file_watcher = true,
	},
}

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{
			"<leader>n|",
			function()
				require("neo-tree").setup(opts)
				vim.cmd([[:Neotree toggle]])
			end,
			mode = "",
			desc = "File system tree",
		},
		{
			"<leader>nb",
			function()
				require("neo-tree").setup(opts)
				vim.cmd([[:Neotree toggle show buffers right]])
			end,
			mode = "",
			desc = "Open buffers tree",
		},
		{
			"<leader>ns",
			function()
				require("neo-tree").setup(opts)
				vim.cmd([[:Neotree float git_status]])
			end,
			mode = "",
			desc = "Git status tree",
		},
	},
	opts = opts,
}
