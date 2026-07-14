return {
  -- 1. Extend the Formatter Engine (Conform)
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        qml = { 'qmlformat' },
      },
    },
  },

  -- 2. Extend the Language Server Engine (LSP)
  {
    'neovim/nvim-lspconfig',
    optional = true,
    opts = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      
      vim.lsp.config('qmlls', {
        capabilities = capabilities,
        -- Add the '-E' flag to force QML2_IMPORT_PATH resolution
        cmd = { 'qmlls', '-E' },
        filetypes = { 'qml', 'qmljs' },
      })
      
      vim.lsp.enable('qmlls')
    end,
  }
}
