require('bufferline').setup({
    highlights = require("catppuccin.groups.integrations.bufferline").get(),
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
  })
