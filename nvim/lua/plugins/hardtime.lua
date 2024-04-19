return {
  "m4xshen/hardtime.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim"
  },
  enabled = io.popen("uname"):read("*l") ~= "Darwin", 
  opts = {}
}

