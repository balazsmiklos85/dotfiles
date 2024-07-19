return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'mfussenegger/nvim-dap'
  },
  opts = {
    icons = { expanded = '▾', collapsed = '▸' },
    mappings = {
        expand = '<CR>',
        open = 'o',
        remove = 'd',
        edit = 'e',
        repl = 'r',
    },
    sidebar = {
        elements = {
            { id = 'scopes', size = 0.4 },
            { id = 'breakpoints', size = 0.3 },
            { id = 'stacks', size = 0.3 },
        },
        width = 40,
        position = 'left',
    },
    tray = {
        elements = { 'repl' },
        height = 10,
        position = 'bottom',
    },
}
}

