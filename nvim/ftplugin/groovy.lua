vim.lsp.config("groovyls", {
	cmd = {
		"java",
		"-jar",
		os.getenv("HOME") .. "/.local/bin/groovy-language-server/build/libs/groovy-language-server-all.jar",
	},
})

vim.lsp.enable("groovyls")
