return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Load before other plugins
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- or "latte", "frappe", "macchiato"
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
          },
          cmp = true,
          telescope = true,
          which_key = true,
        },
      })
    end,
  },
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("onedark").setup({
        style = "darker",
      })
      -- Enable theme
      require("onedark").load()
    end,
  },
}
