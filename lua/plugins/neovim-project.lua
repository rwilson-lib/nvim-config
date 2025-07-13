return {
  "coffebar/neovim-project",
  cmd = {
    "NeovimProjectLoadSession",
  },
  keys = {
    { "<leader>fp", "<cmd>NeovimProjectDiscover history<CR>", desc = "Find Projects" },
    { ";p", "<cmd>NeovimProjectLoadRecent<CR>", desc = "Recent Project" },
    { "<Leader>pr", "<cmd>NeovimProjectLoadRecent<CR>", desc = "Recent Project" },
  },
  priority = 100,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    -- optional picker
    -- { "nvim-telescope/telescope.nvim" },
    { "Shatur/neovim-session-manager", event = "VeryLazy" },
  },
  opts = {
    projects = { -- define project roots
      "~/.config/*",
      "~/Documents/Projects/*",
    },
    session_manager_opts = {
      autosave_ignore_dirs = {
        vim.fn.expand("~"), -- don't create a session for $HOME/
        "/tmp",
        "~/tmp",
      },
    },
    picker = {
      type = "snacks", -- or "telescope"
      preview = {
        enabled = true, -- show directory structure in Telescope preview
        git_status = true, -- show branch name, an ahead/behind counter, and the git status of each file/folder
        git_fetch = false, -- fetch from remote, used to display the number of commits ahead/behind, requires git authorization
        show_hidden = true, -- show hidden files/folders
      },
    },
  },
  init = function()
    -- enable saving the state of plugins in the sessions
    vim.opt.sessionoptions:append("globals") -- save global variables that start with an uppercase letter and contain at least one lowercase letter.
  end,
}
