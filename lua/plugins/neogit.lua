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
              layout = "diff2_vertical",
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
      kind = "tab",
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
