return {
  "coffebar/neovim-project",
  cmd = {
    "NeovimProjectLoadSession",
  },
  keys = {
    {
      "g/p",
      "<cmd>NeovimProjectDiscover history<CR>",
      desc = "Find Projects",
    },
    {
      "<leader>pf",
      "<cmd>NeovimProjectDiscover history<CR>",
      desc = "Find Projects",
    },
    {
      "<Leader>pr",
      "<cmd>NeovimProjectLoadRecent<CR>",
      desc = "Recent Project",
    },
  },
  priority = 100,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- optional picker
    { "nvim-telescope/telescope.nvim" },
    { "Shatur/neovim-session-manager" },
  },
  opts = {
    projects = { -- define project roots
      "~/.config/*",
      "~/Documents/Projects/*",
    },
    picker = {
      type = "telescope", -- or "fzf-lua"
    },
  },
  init = function()
    -- enable saving the state of plugins in the sessions
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
}
