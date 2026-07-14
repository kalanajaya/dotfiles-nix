return {
  -- 1. Plug into the Formatter Engine (Conform)
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.cpp = { 'clang-format' }
      opts.formatters_by_ft.c = { 'clang-format' }
    end,
  },

  -- 2. Plug into the Debugger Engine (nvim-dap)
  {
    'mfussenegger/nvim-dap',
    optional = true,
    config = function()
      local dap = require('dap')
      dap.configurations.cpp = {
        {
          name = 'Launch C/C++ Executable',
          type = 'codelldb',
          request = 'launch',
          program = function()
            local file_path = vim.fn.expand('%:p')
            local output_name = vim.fn.getcwd() .. '/a.out'
            local compile_cmd = string.format('g++ "%s" -o "%s" -g -O0', file_path, output_name)
            
            vim.fn.system(compile_cmd)
            if vim.v.shell_error ~= 0 then
              vim.notify('Compilation failed!', vim.log.levels.ERROR)
              return nil
            end
            return output_name
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }
    end,
  },

  -- 3. Plug into the Language Server Engine (LSP) Using Neovim 0.11+ Styles
  {
    'neovim/nvim-lspconfig',
    optional = true,
    opts = function()
      -- 1. Grab the global capabilities from blink.cmp
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- 2. Configure clangd via the native 0.11 API
      vim.lsp.config('clangd', {
        cmd = { 'clangd', '--background-index', '--clang-tidy' },
        filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
        capabilities = capabilities,
      })

      -- 3. Tell Neovim to activate it
      vim.lsp.enable('clangd')
    end,
  }
}
