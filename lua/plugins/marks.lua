return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("marks").setup({
      -- whether the shada file is updated after modifying uppercase marks. default false
      force_write_shada = true,
    })
  end,
}
