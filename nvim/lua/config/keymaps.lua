local wk = require("which-key")

wk.add({
	{ "<leader>c", group = "Code formatting" },
	{ "<leader>d", group = "Debug Adapter Protocol UI" },
	{ "<leader>n", group = "Neotree files" },
	{ "<leader>f", group = "Find with Telescope" },
})

vim.keymap.set("n", "<localleader>do", ":DiffviewOpen<CR>")
vim.keymap.set("n", "<localleader>dc", ":DiffviewClose<CR>")

wk.add({
	{ "<localleader>d", group = "Diffview" },
	{ "<localleader>do", desc = "Open diff view", mode = "n" },
	{ "<localleader>dc", desc = "Close diff view", mode = "n" },
})

if package.loaded["obsidian"] then
	vim.keymap.set("n", "<localleader>od", ":ObsidianDailies<CR>")
	vim.keymap.set("n", "<localleader>of", ":ObsidianFollow<CR>")
	vim.keymap.set("n", "<localleader>on", ":ObsidianNew<CR>")
	vim.keymap.set("n", "<localleader>ot", ":ObsidianTemplate<CR>")

	wk.add({
		{ "<localleader>o", group = "Notes" },
		{ "<localleader>od", desc = "Dailies", mode = "n" },
		{ "<localleader>of", desc = "Follow", mode = "n" },
		{ "<localleader>on", desc = "New", mode = "n" },
		{ "<localleader>ot", desc = "Template", mode = "n" },
	})
end

vim.keymap.set("n", "<leader>sh", ":setlocal spell spelllang=hu<CR>")
vim.keymap.set("n", "<leader>se", ":setlocal spell spelllang=en_us<CR>")
vim.keymap.set("n", "<leader>sb", ":setlocal spell spelllang=en_gb<CR>")
vim.keymap.set("n", "<leader>sg", ":setlocal spell spelllang=de<CR>")

wk.add({
	{ "<leader>s", group = "Spell check" },
	{ "<leader>sh", desc = "Hungarian", mode = "n" },
	{ "<leader>se", desc = "American English", mode = "n" },
	{ "<leader>sb", desc = "British English", mode = "n" },
	{ "<leader>sg", desc = "German", mode = "n" },
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
		vim.keymap.set("n", "<localleader>cf", vim.lsp.buf.format, opts)
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
			{ "<localleader>cf", desc = "Format", mode = "n" },
		})
	end,
})
