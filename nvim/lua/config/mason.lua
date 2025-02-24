local lsps_to_install = {
	-- Lua
	"lua_ls",
}
local tools_to_install = {
	-- Lua
	"stylua",
}

if vim.fn.executable("cargo") == 1 then
	-- Rust
	table.insert(lsps_to_install, "rust_analyzer")
	table.insert(tools_to_install, "codelldb")
end

if vim.fn.executable("npm") == 1 then
	-- Angular
	table.insert(lsps_to_install, "angularls")
	-- HTML, JavaScript, CSS, GraphQL, JSON, YAML, Markdown
	table.insert(tools_to_install, "prettier")
end

if vim.fn.executable("pylsp") == 1 then
	-- Python
	table.insert(tools_to_install, "ruff")
end

if vim.fn.executable("rvm") == 1 then
	-- Ruby
	table.insert(lsps_to_install, "rubocop")
	table.insert(lsps_to_install, "ruby_lsp")
end

if vim.fn.executable("sdk") == 1 then
	-- Java
	table.insert(lsps_to_install, "jdtls")
	table.insert(tools_to_install, "google-java-format")
	table.insert(tools_to_install, "java-debug-adapter")
	table.insert(tools_to_install, "java-test")
end

if vim.fn.executable("terraform") == 1 then
	-- Terraform
	table.insert(lsps_to_install, "terraformls")
end

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = lsps_to_install,
})
require("mason-tool-installer").setup({
	ensure_installed = tools_to_install,
})
