return {
  {
    'lervag/vimtex',
    lazy = false, -- Load on startup for .tex files
    init = function()
      -- Use zathura as the PDF viewer (standard for Linux/Hyprland setups)
      vim.g.vimtex_view_method = 'zathura'
    end,
  },
}
