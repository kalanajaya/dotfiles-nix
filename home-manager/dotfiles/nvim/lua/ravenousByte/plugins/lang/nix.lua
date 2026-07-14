return {
  -- Formatter
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.nix = { 'alejandra' }
    end,
  },
  
  -- LSP
  {
    'neovim/nvim-lspconfig',
    optional = true,
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- 1. Configure the server
      vim.lsp.config('nixd', {
        capabilities = capabilities,
      })
      
      -- 2. Enable the server
      vim.lsp.enable('nixd')
    end,
  },
}
