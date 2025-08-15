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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.textwidth = 79
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

vim.o.autoread = true

-- Reload the file if it's changed outside Neovim
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  command = "checktime",
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Your customization here
    -- Make background transparent
    vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
    vim.cmd("hi NormalNC guibg=NONE ctermbg=NONE")
    vim.cmd("hi EndOfBuffer guibg=NONE ctermbg=NONE")
    vim.cmd("hi WinSeparator guibg=none guifg=white")
  end,
})

-- print(vim.env.TERM_PROGRAM or "Unknown")
