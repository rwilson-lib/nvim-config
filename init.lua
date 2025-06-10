require("config.lazy")
require("core")

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local event = vim.v.event
    if event.operator == "y" and event.regtype == "V" then
      vim.highlight.on_yank { higroup = "IncSearch", timeout = 150 }
    end
  end,
  desc = "Highlight yanked lines",

})
