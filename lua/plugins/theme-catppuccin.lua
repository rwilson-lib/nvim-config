return {
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
}
