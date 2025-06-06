vim.g.mapleader = " "   -- set leader to SPC

local keymap = vim. keymap -- for conciseness

-- normal map
keymap.set("n", ";;", function()
  vim.cmd('b#')
end, { desc = "switch to the previous buffer" })

-- insert map
keymap. set ("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
