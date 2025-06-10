vim.g.mapleader = " "         -- set leader to SPC

local keymap = vim.keymap.set -- for conciseness

-- normal map
keymap("n", ";;", function()
  local win = vim.v.count
  if win == 0 then
    vim.cmd('b#')
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

keymap("n", "<leader>ot", "<cmd>Neotree toggle<CR>", opts("[T]oggle Neotree"))
keymap("n", "<leader>og", "<cmd>Neogit<CR>", opts("Neogit"))
keymap("n", "<leader>od", "<cmd>Dbee toggle<CR>", opts("Dbee"))


keymap("n", "_", "<cmd>Oil<CR>", opts("Toggle Oil"))
