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

local isSsh = not(not(os.getenv("SSH_CLIENT")) and not(os.getenv("SSH_TTY")))

local plugins = {
  {'airblade/vim-gitgutter', {}},
  {'neovim/nvim-lspconfig', {}},
  {'mfussenegger/nvim-jdtls', {}},
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {'nvim-treesitter/nvim-treesitter', {}},
  {
    'sainnhe/everforest',
    enabled = isSsh
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  },
  {
    'epwalsh/obsidian.nvim',
    name = 'obsidian',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'hrsh7th/nvim-cmp'
    }
  },
}

local opts = {
}

require('lazy').setup(plugins, opts)

