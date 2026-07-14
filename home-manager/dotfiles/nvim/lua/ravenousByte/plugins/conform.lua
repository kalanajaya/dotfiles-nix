return {
  -- Autoformat
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      { '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, desc = '[F]ormat buffer' },
    },
    opts = {
      notify_on_error = false,
      format_on_save = {
        timeout_ms = 2000,
        lsp_format = 'fallback',
      },
      formatters_by_ft = {}, -- Leave this EMPTY. Languages will populate it.
    },
  },
}
