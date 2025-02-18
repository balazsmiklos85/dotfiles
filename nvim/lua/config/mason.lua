local util = require("util.functions")

local lsps_to_install = {
	-- Java
	"jdtls",
	-- Lua
	"lua_ls",
}
local tools_to_install = {
	-- HTML, JavaScript, CSS, GraphQL, JSON, YAML, Markdown
	"prettier",
	-- Java
	"google-java-format",
	"java-debug-adapter",
	"java-test",
	-- Lua
	"stylua",
}

if util.is_macos() or util.is_wsl() or util.is_vm() then
	table.insert(lsps_to_install, "angularls")
	table.insert(lsps_to_install, "terraformls")
else
	-- Ruby
	table.insert(lsps_to_install, "rubocop")
	table.insert(lsps_to_install, "ruby_lsp")
	-- Rust
	table.insert(lsps_to_install, "rust_analyzer")
	table.insert(tools_to_install, "codelldb")
end
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = lsps_to_install,
})
require("mason-tool-installer").setup({
	ensure_installed = tools_to_install,
})
