--[[
Everything related to flutter + firebase
]]
--
return {
  -- Flutter =================================================
  {
    'akinsho/flutter-tools.nvim',
    lazy = false, -- Load immediately for Dart/Flutter files
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim',
    },
    config = function()
      require('flutter-tools').setup {
        lsp = {
          color_utils = { enabled = true },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
          },
        },
        debugger = {
          enabled = true,
          register_configurations = function(_)
            require('dap').configurations.dart = {
              {
                type = 'dart',
                request = 'launch',
                name = 'Launch flutter',
                dartSdkPath = 'dart', -- Adjust if dart is not in path
                flutterSdkPath = 'flutter', -- Adjust if flutter is not in path
                program = '${file}',
                cwd = '${workspaceFolder}',
              },
            }
          end,
        },
      }

      --[[
      -- Set keymaps only when this plugin is loaded
      local map = vim.keymap.set
      map('n', '<leader>fr', '<cmd>FlutterRun<cr>', { desc = 'Run Flutter' })
      map('n', '<leader>fR', '<cmd>FlutterRestart<cr>', { desc = 'Hot Restart' })
      map('n', '<leader>fq', '<cmd>FlutterQuit<cr>', { desc = 'Quit Flutter' })
      map('n', '<leader>fd', '<cmd>FlutterDevices<cr>', { desc = 'Select Device' })
      map('n', '<leader>fe', '<cmd>FlutterEmulators<cr>', { desc = 'List Emulators' })    

      ]]
      --
    end,
  },

  -- Firebase ==================================================
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    opts = {
      servers = {
        -- TypeScript/JavaScript Server
        ts_ls = {},
        -- ESLint is crucial for Firebase Functions to catch deploy errors early
        eslint = {
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
        },
      },
    },
  },

  -- Formatting for TS/JS files
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
      },
    },
  },
}
