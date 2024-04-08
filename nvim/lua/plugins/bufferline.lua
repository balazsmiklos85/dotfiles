return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons'
  },
  opts = {
    options = {
      offsets = {
        {
          filetype = "neo-tree",
          text = "Folder",
          text_align = "left",
          separator = "│",
        },
        {
          filetype = "dapui_watches",
          text = "Debugger",
          text_align = "left",
          separator = "│",
        },
        {
          filetype = "dbui",
          text = "Database",
          text_align = "left",
          separator = "│",
        },
      },
    }
  }
}

