-- asking when quitting without saving files

return {
  --Closing confirmation
  {
    'yutkat/confirm-quit.nvim',
    event = 'CmdlineEnter',
    opts = {},
  },
}
