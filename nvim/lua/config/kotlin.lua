vim.lsp.config('kotlin_lsp', {
	cmd = {
		os.getenv("HOME") .. '/.local/share/nvim/mason/packages/kotlin-lsp/kotlin-server-263.4702.0/bin/intellij-server',
		'--stdio',
	},
	filetypes = { 'kotlin', 'kts' },
	root_markers = { 'settings.gradle', 'settings.gradle.kts', 'build.gradle', 'build.gradle.kts', '.git' },
})

vim.lsp.enable('kotlin_lsp')
