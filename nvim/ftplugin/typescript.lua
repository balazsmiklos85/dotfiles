local project_library_path = vim.fn.getcwd()
local angular_json = vim.fn.findfile("angular.json", project_library_path .. ";")
if angular_json ~= "" then
	project_library_path = vim.fn.fnamemodify(angular_json, ":p:h")
end
local cmd =
	{ "ngserver", "--stdio", "--tsProbeLocations", project_library_path, "--ngProbeLocations", project_library_path }

require("lspconfig").angularls.setup({
	cmd = cmd,
	root_dir = function() return project_library_path end,
	on_new_config = function(new_config, new_root_dir)
		new_config.cmd = cmd
		new_config.root_dir = new_root_dir
	end,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx" },
})
