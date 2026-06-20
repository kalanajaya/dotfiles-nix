-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Show diagnostic popup on cursor hover
vim.api.nvim_create_autocmd('CursorHold', {
  desc = 'Show diagnostic floating window on hover',
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

