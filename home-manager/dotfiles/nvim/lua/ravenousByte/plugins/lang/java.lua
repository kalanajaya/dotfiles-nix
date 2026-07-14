return {
  {
    'nvim-java/nvim-java',
    ft = 'java', -- CRITICAL: Only load this plugin for Java files
    dependencies = {
      'mfussenegger/nvim-dap', -- Ensure DAP is available to configure
    },
    config = function()
      -- 1. Setup nvim-java first to prepare the environment
      require('java').setup()
      vim.lsp.enable('jdtls')

      -- 2. Setup the Java Debugger (DAP)
      -- This was extracted from your old debug.lua
      local dap = require('dap')
      
      dap.adapters.java = {
        type = 'server',
        port = 8000,
        host = '127.0.0.1',
        options = {
          connect_timeout = 30000,
        },
        command = {
          'java',
          '-jar',
          -- ⚠️ NIXOS WARNING: See the note below about this path!
          vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/vscode-java-test/extension/server/com.microsoft.java.test.runner-*.jar'),
        },
      }

      dap.configurations.java = {
        {
          type = 'java',
          request = 'launch',
          name = 'Launch Current Java File',
          mainClass = function()
            return vim.fn.input('Path to Main Class: ', 'Main', 'file')
          end,
          cwd = '${workspaceFolder}',
        },
      }
    end,
  },
}
