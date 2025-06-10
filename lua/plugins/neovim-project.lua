return {
  "coffebar/neovim-project",
  lazy = false,
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
    }
  },
  init = function()
    -- enable saving the state of plugins in the sessions
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
    vim.keymap.set('n', 'g/p', '<cmd>NeovimProjectDiscover history<CR>', { desc = 'Telescope find projects' })
  end,
}
