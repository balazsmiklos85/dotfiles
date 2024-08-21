local wk = require("which-key")

wk.add({
	{ "<leader>c", group = "Code formatting" },
	{ "<leader>d", group = "Debug Adapter Protocol UI" },
	{ "<leader>n", group = "Neotree files" },
	{ "<leader>f", group = "Find with Telescope" },
})

vim.keymap.set("n", "<leader>od", ":ObsidianDailies<CR>")
vim.keymap.set("n", "<leader>on", ":ObsidianNew<CR>")

wk.add({
	{ "<leader>o", group = "Notes" },
	{ "<leader>od", desc = "Dailies", mode = "n" },
	{ "<leader>on", desc = "New", mode = "n" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "<localleader>gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<localleader>gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<localleader>K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<localleader>gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<localleader><C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<localleader>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<localleader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<localleader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<localleader>gr", vim.lsp.buf.references, opts)

		wk.add({
			{ "<localleader>g", group = "Go to..." },
			{ "<localleader>gD", desc = "Declaration", mode = "n" },
			{ "<localleader>gd", desc = "Definition", mode = "n" },
			{ "<localleader>gi", desc = "Implementation", mode = "n" },
			{ "<localleader>gr", desc = "References", mode = "n" },
			{ "<localleader>K", desc = "Hover", mode = "n" },
			{ "<localleader><C-k>", desc = "Signature help", mode = "n" },
			{ "<localleader>D", desc = "Type definition", mode = "n" },
			{ "<localleader>rn", desc = "Rename", mode = "n" },
			{ "<localleader>ca", desc = "Code action", mode = "nv" },
		})
	end,
})
