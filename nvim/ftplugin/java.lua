local mason_packages = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/"

local config = {
  cmd = { mason_packages .. "jdtls/bin/jdtls" },
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

