require('neo-tree').setup {
      enable_git_status = true,
      close_if_last_window = true,
      auto_clean_after_session_restore = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        hijack_netrw_behavior = "open_current",
        use_libuv_file_watcher = true,
      },
    }

