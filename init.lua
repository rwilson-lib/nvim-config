require("config.lazy")
require("core")

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    local event = vim.v.event
    -- Check if the operator was 'y' (yank)
    -- And if the selection type was 'v' (character-wise), 'V' (line-wise), or 'b' (block-wise)
    if event.operator == "y" and (event.regtype == "v" or event.regtype == "V" or event.regtype == "b") then
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
    end
  end,
  desc = "Highlight yanked text (all types)",
})
