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

if util.is_macos() then
	table.insert(lsps_to_install, "kotlin_language_server")
else
	-- Ruby
	table.insert(lsps_to_install, "rubocop")
	table.insert(lsps_to_install, "ruby_lsp")
	table.insert(lsps_to_install, "sorbet")
	table.insert(lsps_to_install, "solargraph")
end
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = lsps_to_install,
})
require("mason-tool-installer").setup({
	ensure_installed = tools_to_install,
})
