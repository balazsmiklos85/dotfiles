local lspconfig = require('lspconfig')

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

