------------------------------------------------------------------------------
--- CODE RUNNER -- FOR RUNNING A SINGLE FILE---------------------------------- using <F6>
------------------------------------------------------------------------------
return {
  { -- Easy way to compile and run a single file
    'CRAG666/code_runner.nvim',
    ft = { 'c', 'cpp', 'python', 'java' }, -- Only load for C/C++ files
    config = function()
      require('code_runner').setup {
        -- Configuration here (optional)
        -- You can configure the terminal window, default command, etc.
        filetype = {
          -- This command compiles the current file and then runs it
          java = {
            'cd "$dir" &&',
            'javac "$fileName" &&',
            'java "$fileNameWithoutExt"',
          },
          python = 'python3 -u',
          cpp = 'cd "$dir" && g++ "$fileName" -o "$fileNameWithoutExt" && "./$fileNameWithoutExt"',
          dart = 'flutter run',
        },
      }

      -- Set a keymap to run the code (e.g., F6)
      vim.keymap.set('n', '<F6>', '<cmd>RunCode<CR>', { desc = 'Run Current File' })
    end,
  },
}
