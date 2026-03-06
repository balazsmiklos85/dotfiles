vim.g.dbs = {
    -- { name = 'dev', url =  vim.fn.system('get-dev-db'):gsub("%s+", "") },
    { name = 'staging', url = vim.fn.system('get-staging-db'):gsub("%s+", "") },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "sql", "mysql", "mariadb" },
  callback = function()
    vim.b.db = vim.g.dbs[1].url
  end,
})
