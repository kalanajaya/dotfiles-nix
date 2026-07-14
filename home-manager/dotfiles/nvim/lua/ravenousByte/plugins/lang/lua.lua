return {
  -- 1. Extend the Formatter Engine (Conform)
  {
    'stevearc/conform.nvim',
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
      },
      formatters = {
        stylua = {
          -- Optional: Enforce specific formatting rules inline if you don't use a stylua.toml file
          prepend_args = { '--indent-type', 'Spaces', '--indent-width', '2' },
        },
      },
    },
  },

  -- 2. Extend the Language Server Engine (LSP)
  {
    'neovim/nvim-lspconfig',
    optional = true,
    opts = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        cmd = { 'lua-language-server' },
        filetypes = { 'lua' },
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (Neovim uses LuaJIT)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files for auto-completion
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          },
        },
      })
      
      vim.lsp.enable('lua_ls')
    end,
  }
}
