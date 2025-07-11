vim.g.mapleader = " " -- set leader to SPC

local keymap = vim.keymap.set -- for conciseness

-- normal map
keymap("n", ";;", function()
  local win = vim.v.count
  if win == 0 then
    vim.cmd("b#")
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

keymap("n", "<leader>ot", function()
  local arg = vim.v.count1
  if arg == 1 then
    vim.cmd("ToggleTerm")
  else
    vim.cmd(string.format("%dToggleTerm", arg))
  end
end, { desc = "Toggle terminal" })

keymap("v", "<leader>ot", function()
  local arg = vim.v.count1
  if arg == 1 then
    vim.cmd("ToggleTermSendVisualSelection")
  else
    vim.cmd(string.format("ToggleTermSendVisualSelection %d", arg))
  end
end, { desc = "Toggle terminal send" })

keymap({ "n", "v" }, "ga.", "<cmd>CodeCompanion<CR>", opts("CodeCompanion Chat"))
keymap({ "n", "v" }, "gaC", "<cmd>CodeCompanionChat<CR>", opts("CodeCompanion Chat"))
keymap({ "n", "v" }, "ga/", "<cmd>CodeCompanionActions<CR>", opts("CodeCompanion Action"))
keymap({ "n", "v" }, "ga:", "<cmd>CodeCompanionCmd<CR>", opts("CodeCompanion Command"))

keymap("n", "_", "<cmd>Oil<CR>", opts("Toggle Oil"))
