return {
  -- 1. Formatters
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.python = { 'isort', 'black' }
    end,
  },

  -- 2. Debugger (DAP)
  {
    'mfussenegger/nvim-dap',
    optional = true,
    config = function()
      local dap = require('dap')
      dap.configurations.python = {
        {
          type = 'python',
          request = 'launch',
          name = 'Launch Current Python File',
          program = '${file}',
          pythonPath = function()
            -- On NixOS, we rely on the system python, not Mason
            return 'python'
          end,
        },
      }
    end,
  },

  -- 3. LSP
  {
    'neovim/nvim-lspconfig',
    optional = true,
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      
      -- 1. Configure the server (Native Neovim API)
      vim.lsp.config('pyright', {
        capabilities = capabilities,
      })
      
      -- 2. Enable the server
      vim.lsp.enable('pyright')
    end,
  },}
