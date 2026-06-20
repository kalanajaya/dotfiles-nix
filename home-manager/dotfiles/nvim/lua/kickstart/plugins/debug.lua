-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dap.defaults.fallback.terminal_win_cmd = '50vsplit new'
    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'debugpy',
        'codelldb',
        'vscode-java',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- ------------------------------------- modification start---------------
    -- Java Adapter Setup
    dap.adapters.java = {
      type = 'server',
      port = 8000,
      host = '127.0.0.1',
      options = {
        -- Set a timeout for the server to start (optional)
        connect_timeout = 30000,
      },
      -- This command relies on Mason setting up the necessary Java debug server components
      command = {
        'java',
        '-jar',
        -- Path to the VS Code Debug Server JAR installed by Mason
        vim.fn.glob(vim.fn.stdpath 'data' .. '/mason/packages/vscode-java-test/extension/server/com.microsoft.java.test.runner-*.jar'),
      },
    }

    dap.configurations.java = {
      {
        type = 'java',
        request = 'launch',
        name = 'Launch Current Java File',
        -- This configuration relies on the Classpath being correctly set up in the terminal
        mainClass = function()
          return vim.fn.input('Path to Main Class: ', 'Main', 'file')
        end,

        cwd = '${workspaceFolder}',
      },
    }

    -- === Python Configuration ===
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch Current Python File',
        program = '${file}',
        pythonPath = function()
          -- Uses the python executable from Mason's debugpy venv path
          local mason_debugpy = vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python'
          if vim.fn.filereadable(mason_debugpy) then
            return mason_debugpy
          else
            return require('dap.utils').get_python_path() or 'python'
          end
        end,
      },
    }

    -- === C/C++ Configuration ===
    dap.configurations.cpp = {
      {
        name = 'Launch C/C++ Executable',
        type = 'codelldb',
        request = 'launch',
        program = function()
          local file_path = vim.fn.expand '%:p'
          local output_name = vim.fn.getcwd() .. '/a.out'

          -- Define the compilation command with the necessary -g flag
          -- Adjust flags (-O0 is optional but recommended for debugging)
          local compile_cmd = string.format('g++ "%s" -o "%s" -g -O0', file_path, output_name)

          -- Execute the command synchronously
          local job = vim.fn.system(compile_cmd)

          -- Check if compilation succeeded
          if vim.v.shell_error ~= 0 then
            -- Compilation failed, show error message
            vim.notify('Compilation failed! Check build output in the terminal.', vim.log.levels.ERROR)
            -- Return nil to stop DAP from launching
            return nil
          end

          vim.notify('Compilation successful. Starting debugger...', vim.log.levels.INFO)

          -- Return the path to the newly created executable
          return output_name
          --[[
          -- Prompts the user for the path to the compiled executable (e.g., ./a.out)
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/' .. vim.fn.expand '%:t:r', 'file')
					]]
          --
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    -- ------------------------------------- modification end -----------------

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
