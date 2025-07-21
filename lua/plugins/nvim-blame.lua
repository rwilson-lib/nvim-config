return {
  "FabijanZulj/blame.nvim",
  cmd = { "BlameToggle" },

  config = function()
    require("blame").setup({})
  end,

  opts = {
    blame_options = { "-w" },
  },
}
