local autocmd = vim.api.nvim_create_autocmd

local yank_group = vim.api.nvim_create_augroup("HighlightYank", { clear = true })
autocmd("TextYankPost", {
  group = yank_group,
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

local sql_group = vim.api.nvim_create_augroup("SqlGroup", { clear = true })
autocmd("FileType", {
  group = sql_group,
  pattern = "sql",
  callback = function()
    if vim.fn.exists("*db_ui#statusline") == 1 then
      local statusline = vim.fn["db_ui#statusline"]({
        show = { "db_name", "schema", "table" },
        separator = " > ",
        prefix = "",
      })
      vim.api.nvim_set_option_value("winbar", statusline, { scope = "local" })
    end
  end,
})

local gitcommit_group = vim.api.nvim_create_augroup("VisualRelativeNumbers", { clear = true })
autocmd("FileType", {
  group = gitcommit_group,
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.textwidth = 79
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

local checktime_group = vim.api.nvim_create_augroup("CheckTime", { clear = true })
-- Reload the file if it's changed outside Neovim
autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = checktime_group,
  pattern = "*",
  callback = function()
    --Only run checktime for nomal files buffer
    if vim.bo.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})

local buf_change_group = vim.api.nvim_create_augroup("BufChange", { clear = true })
autocmd("FileChangedShellPost", {
  group = buf_change_group,
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})

local my_colors_group = vim.api.nvim_create_augroup("MyColors", { clear = true })
autocmd("ColorScheme", {
  group = my_colors_group,
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

local rel_num_group = vim.api.nvim_create_augroup("VisualRelativeNumbers", { clear = true })

autocmd("ModeChanged", {
  group = rel_num_group,
  pattern = "*:[ovV\x16]", -- match entering any Visual mode (character, line, block)
  callback = function()
    vim.wo.relativenumber = true
  end,
})

autocmd("ModeChanged", {
  group = rel_num_group,
  pattern = "[vV\x16]:*", -- match leaving any Visual mode (character, line, block)
  callback = function()
    vim.wo.relativenumber = false
  end,
})

autocmd("ModeChanged", {
  group = rel_num_group,
  pattern = "*:no*", -- match any old mode → operator-pending flagged
  callback = function()
    vim.wo.relativenumber = true
  end,
})

autocmd("ModeChanged", {
  group = rel_num_group,
  pattern = "no*:*", -- leaving operator-pending flagged
  callback = function()
    vim.wo.relativenumber = false
  end,
})

autocmd("CmdlineEnter", {
  group = rel_num_group,
  pattern = ":",
  callback = function()
    vim.opt.relativenumber = false
  end,
})

local typr_group = vim.api.nvim_create_augroup("Typr", { clear = true })
autocmd("FileType", {
  group = typr_group,
  pattern = "typr",
  callback = function()
    vim.g.codeium_filetypes = {
      typr = false,
    }
  end,
})
