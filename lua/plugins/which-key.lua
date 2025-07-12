return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    spec = {
      { ";g", group = "Gitsigns" },
      { "<leader>a", group = "ai" },
      { "<leader>f", group = "Find" },
      { "<leader>s", group = "Search" },
      { "<leader>u", group = "Toggle" },
      { "<leader>g", group = "Git" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
