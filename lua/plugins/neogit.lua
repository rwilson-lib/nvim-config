return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "sindrets/diffview.nvim",
      cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
      config = function()
        require("diffview").setup({
          view = {
            default = {
              layout = "diff2_horizontal",
            },
          },
        })
      end,
    },
    {
      "nvim-telescope/telescope.nvim", -- optional
      optional = true,
    },
  },
  config = true
}
