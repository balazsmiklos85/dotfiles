require("lspconfig").terraformls.setup({
	filetypes = { "terraform", "tf", "terraform-vars" },
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
