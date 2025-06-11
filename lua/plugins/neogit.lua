return {
  "NeogitOrg/neogit",
  cmd = "Neogit", -- lazy-load when :Neogit is run
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
  config = function()
    require("neogit").setup({
      commit_popup = {
        kind = "vsplit",
      },
      preview_buffer = {
        kind = "floating",
      },
      integrations = {
        diffview = true,
      },
    })
  end,
}
