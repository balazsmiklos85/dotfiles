local mason_path = os.getenv("HOME") .. "/.local/share/nvim/mason/"
local mason_packages_path = mason_path .. "packages/"
local sonarlint_analyzers_path = mason_path .. "/share/sonarlint-analyzers/"

return {
  'https://gitlab.com/schrieveslaach/sonarlint.nvim',
  dependencies = {
    'neovim/nvim-lspconfig'
  },
  opts = {
    server = {
      cmd = {
        mason_packages_path .. "sonarlint-language-server/sonarlint-language-server",
        '-stdio',
        '-analyzers',
        vim.fn.expand(sonarlint_analyzers_path .. "sonarjava.jar"),
      }
    },
    filetypes = {
      'java',
    }
  }
}
