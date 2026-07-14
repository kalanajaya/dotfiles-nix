return {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false }, -- Disable italics in comments
          sidebars = 'transparent', -- Make sidebars transparent
          floats = 'transparent', -- Make floating windows transparent
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
      vim.cmd.colorscheme 'tokyonight-night'

      -- Sets the background highlight group to NONE, allowing terminal transparency to show through
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NonText', { bg = 'none' })

      -- MAKE OTHER WINDOWS TRANSPARENT (Crucial Fix)
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' }) -- Normal Non-Current Window
      vim.api.nvim_set_hl(0, 'VertSplit', { bg = 'none' }) -- Vertical Splitter Line

      -- Important: Also set transparency for common elements like floating windows and sidebars
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    end,
  },

}
