return {
  "FabijanZulj/blame.nvim",
  event = "VeryLazy",

  config = function()
    require("blame").setup({})
  end,

  opts = {
    blame_options = { "-w" },
  },
}
