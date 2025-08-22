return {
  {
    "anuvyklack/hydra.nvim",
    config = function()
      local Hydra = require("hydra")

      Hydra({
        name = "Window Control",
        mode = "n",
        body = "<C-w>",
        heads = {
          { "h", "<C-w>h" },
          { "j", "<C-w>j" },
          { "k", "<C-w>k" },
          { "l", "<C-w>l" },
          { "s", "<C-w>s" },
          { "v", "<C-w>v" },
          { "+", "<C-w>+" },
          { "-", "<C-w>-" },
          { "<", "<C-w><" },
          { ">", "<C-w>>" },
          { "=", "<C-w>=" },
          { "q", "<C-w>q", { exit = true } },
          { "<Esc>", nil, { exit = true } },
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      spec = {
        { "<localleader>g", group = "Gitsigns" },
        { "<leader>a", group = "ai" },
        { "<leader>f", group = "Find" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "Toggle" },
        { "<leader>g", group = "Git" },
        { "<leader>x", group = "Trouble" },
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
  },
}
