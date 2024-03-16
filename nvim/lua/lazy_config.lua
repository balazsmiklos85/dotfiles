local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {'vim-airline/vim-airline', {}},
  {'airblade/vim-gitgutter', {}},
  {'neovim/nvim-lspconfig', {}},
  {'mfussenegger/nvim-jdtls', {}},
  {'junegunn/fzf', {}},
  {'junegunn/fzf.vim', {}},
  {'nvim-treesitter/nvim-treesitter', {}},
  { 'drewtempelmeyer/palenight.vim' },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  }
}

local opts = {
}

require('lazy').setup(plugins, opts)

