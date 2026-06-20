return {
  ------------------------------------------------------------------------------------
  -- TREE SITTER-- FOR AUTOCOMPLETE AND SYNTAX HIGHLIGHTING---------------------------
  ------------------------------------------------------------------------------------
  -- Highlight, edit, and navigate code
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    -- Global configuration and parser location setup
    require("nvim-treesitter").setup({
      -- Auto install disabled (Critical on Nix/NixOS environments)
      auto_install = false,
    })

    -- Explicitly pass your required parsers array to the new installation function
    require("nvim-treesitter").install({
      "bash", "c", "cpp", "diff", "html", "lua", "luadoc",
      "markdown", "markdown_inline", "query", "vim", "vimdoc",
      "java", "latex", "nix"
    })

    -- Enable Treesitter highlighters using Neovim's native 0.11+ API
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { 
        "bash", "c", "cpp", "html", "lua", "markdown", 
        "query", "vim", "java", "tex" , "nix"
      },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
