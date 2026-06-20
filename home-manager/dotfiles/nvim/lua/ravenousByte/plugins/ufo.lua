-- code folding
-- (Minimizing parts inside a scope)

return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    config = function()
      -- Settings for a better folding experience
      vim.o.foldcolumn = '1' -- '0' is not bad either
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- Keymaps
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = 'Open all folds' })
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = 'Close all folds' })

      require('ufo').setup {
        provider_selector = function(bufnr, filetype, buftype)
          return { 'lsp', 'indent' }
        end,
      }
    end,
  },
}
