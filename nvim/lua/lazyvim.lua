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
  { 'rewtempelmeyer/palenight.vim' },
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },
}

local opts = {
}

require('lazy').setup(plugins, opts)

