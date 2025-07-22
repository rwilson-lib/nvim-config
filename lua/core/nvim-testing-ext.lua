local function GoFindOrCreateTest(mode)
  mode = mode or "none" -- default to normal edit

  local function open_or_create(filename)
    -- Check if file is already open in any window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if vim.fn.fnamemodify(buf_name, ":p") == vim.fn.fnamemodify(filename, ":p") then
        vim.api.nvim_set_current_win(win)
        return
      end
    end

    -- File doesn't exist, ask to create
    if vim.fn.filereadable(filename) ~= 1 then
      vim.ui.select({ "Yes", "No" }, {
        prompt = "File not found: " .. filename .. ". Create it?",
      }, function(choice)
        if choice == "Yes" then
          if mode == "vsplit" then
            vim.cmd("vsplit " .. filename)
          elseif mode == "split" then
            vim.cmd("split " .. filename)
          else
            vim.cmd("edit " .. filename)
          end
          vim.notify("Created new file: " .. filename, vim.log.levels.INFO)
        end
      end)
      return
    end

    -- File exists, open in requested mode
    if mode == "vsplit" then
      vim.cmd("vsplit " .. filename)
    elseif mode == "split" then
      vim.cmd("split " .. filename)
    else
      vim.cmd("edit " .. filename)
    end
  end

  local current = vim.fn.expand("%:p")
  if not current:match("%.go$") then
    vim.notify("Not a Go source file.", vim.log.levels.WARN)
    return
  end

  if current:match("_test%.go$") then
    local code_file = current:gsub("_test%.go$", ".go")
    open_or_create(code_file)
  else
    local test_file = current:gsub("%.go$", "_test.go")
    open_or_create(test_file)
  end
end

-- Default (no split)
vim.keymap.set("n", "<leader>tt", function()
  GoFindOrCreateTest("none")
end, { desc = "Toggle Go <-> test file" })
-- Vertical split
vim.keymap.set("n", "<leader>tv", function()
  GoFindOrCreateTest("vsplit")
end, { desc = "Toggle Go <-> test (vsplit)" })
-- Horizontal split
vim.keymap.set("n", "<leader>th", function()
  GoFindOrCreateTest("split")
end, { desc = "Toggle Go <-> test (split)" })
