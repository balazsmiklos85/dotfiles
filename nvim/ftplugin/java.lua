local util = require("util.functions")

local home = os.getenv("HOME")
local mason_packages = home .. "/.local/share/nvim/mason/packages/"
local jdtls_command =
{
	  mason_packages .. "jdtls/bin/jdtls"
}
local lombok_jar = home .. "/.local/bin/lombok.jar"
if util.is_file(lombok_jar) then
	table.insert(jdtls_command, "--jvm-arg=-javaagent:" .. lombok_jar)
end

local config = {
  cmd = jdtls_command,
  root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}

local bundles = {
  vim.fn.glob(mason_packages .. "java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
};

vim.list_extend(bundles, vim.split(vim.fn.glob(mason_packages .. "vscode-java-test/server/*.jar", 1), "\n"))
config['init_options'] = {
  bundles = bundles;
}

require('jdtls').start_or_attach(config)
require('dap').configurations.java = {
  {
    type = 'java';
    request = 'attach';
    name = "Debug (Attach)";
    hostName = "127.0.0.1";
    port = 5005;
  },
}

vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

vim.diagnostic.config({
	float = true,
	jump = {
		float = false,
		wrap = true,
	},
	severity_sort = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	virtual_lines = false,
	virtual_text = true,
})

