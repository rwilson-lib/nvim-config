vim.g.mapleader = " " -- set leader to SPC

local keymap = vim.keymap.set -- for conciseness

keymap("n", ";;", function()
  local win = vim.v.count
  if win == 0 then
    local altbuf = vim.fn.expand("#")
    if altbuf ~= "" then
      vim.cmd("b#")
    else
      require("snacks.picker").recent()
    end
  else
    vim.cmd(string.format("%dwincmd w", win))
  end
end, { desc = "switch to the previous buffer" })

keymap("n", ";w", "<C-w>", { desc = "Send C-w buffer" })

-- command map
keymap("c", "<C-j>", "<Down>", { desc = "Cmd hist next" })
keymap("c", "<C-k>", "<Up>", { desc = "Cmd hist prev" })

-- normal-mode map

local opts = function(desc)
  desc = desc or "" --
  return { silent = true, desc = desc }
end

keymap("n", "<leader>oe", function()
  Snacks.explorer()
end, opts("[T]oggle File Explorer"))
keymap("n", "<leader>og", "<cmd>Neogit<CR>", opts("Neogit"))
keymap("n", "<leader>od", "<cmd>Dbee toggle<CR>", opts("Dbee"))
keymap("n", "<leader>ou", "<cmd>UndotreeToggle<CR>", opts("Undotree"))
keymap("n", "<leader>oz", "<cmd>Lazy<CR>", opts("Lazy"))
keymap("n", "_", "<cmd>Oil<CR>", opts("Toggle Oil"))
keymap("n", "<leader>oT", function()
  Snacks.terminal(nil, {
    win = {
      position = "float",
      border = "single",
    },
  })
end, opts("[T]oggle Terminal float"))

local function open_file_at_line(open_cmd)
  local target = vim.fn.expand("<cWORD>")
  local filename, lnum = string.match(target, "([^:%s]+):?(%d*)")

  if filename then
    vim.cmd(open_cmd .. " " .. filename)
    if lnum ~= "" then
      vim.cmd(tostring(lnum))
    end
  else
    vim.notify("Invalid file format: " .. target, vim.log.levels.WARN)
  end
end

keymap("n", "gFt", function()
  open_file_at_line("tabedit")
end, { desc = "Tab" })

keymap("n", "gFs", function()
  open_file_at_line("topleft split")
end, { desc = "Split" })

keymap("n", "gFv", function()
  open_file_at_line("vsplit")
end, { desc = "Vsplit" })

--
-- keymap("n", "<leader>ot", function()
--   local arg = vim.v.count1
--   if arg == 1 then
--     vim.cmd("ToggleTerm")
--   else
--     vim.cmd(string.format("%dToggleTerm", arg))
--   end
-- end, { desc = "Toggle terminal" })

-- vim.keymap.set("n", "<leader>fp", function()
--   require("neovim-project.project").discover_projects()
-- end, { desc = "Find Projects" })
--
--
-- vim.keymap.set("n", "<leader>fp", function()
--   require("neovim-project.project").discover_projects()
-- end, { desc = "Find Projects" })
--
-- vim.keymap.set("n", ";p", "<cmd>NeovimProjectLoadRecent<CR>", { desc = "Recent Project" })
--
-- vim.keymap.set("n", "<Leader>pr", "<cmd>NeovimProjectLoadRecent<CR>", { desc = "Recent Project" })
