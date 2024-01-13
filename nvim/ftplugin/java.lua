vim.cmd 'setlocal shiftwidth=4 smarttab'
vim.cmd 'setlocal expandtab'
vim.cmd 'setlocal cc=120'

local config = {
    cmd = {os.getenv("HOME") .. '/.local/bin/jdtls/bin/jdtls'},
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)

