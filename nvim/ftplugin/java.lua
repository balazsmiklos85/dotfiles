vim.cmd 'setlocal shiftwidth=4 smarttab'
vim.cmd 'setlocal expandtab'

local config = {
    cmd = {os.getenv("HOME") .. '/.local/bin/jdtls/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)

require('sonarlint').setup({
   server = {
      cmd = {
         'sonarlint-language-server',
         '-stdio',
         '-analyzers',
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarcfamily.jar"),
         vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
      }
   },
   filetypes = {
      'java',
   }
})

