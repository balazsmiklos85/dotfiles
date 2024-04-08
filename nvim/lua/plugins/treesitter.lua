return {
  'nvim-treesitter/nvim-treesitter',
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "java",
      "groovy",
      "json",
      "xml",
      "html",
      "javascript",
      "ruby",
      "rust",
    },
    sync_install = false,
    auto_install = false,

    highlight = {
      enable = true,

      disable = function(lang, buf)
        local max_filesize = 200 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
      end,
    },
  }
}

