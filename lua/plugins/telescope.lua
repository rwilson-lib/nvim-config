return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  }, -- Telescope dependency

  config = function()
    local builtin = require("telescope.builtin")
    local actions = require("telescope.actions")

    -- Key mappings for normal mode

    -- vim.keymap.set("n", "g/f", builtin.find_files, { desc = "Telescope find files" })
    -- vim.keymap.set("n", "g/g", builtin.live_grep, { desc = "Telescope live grep" })
    -- vim.keymap.set("n", "g/b", builtin.buffers, { desc = "Telescope buffers" })
    -- vim.keymap.set("n", "g/?", builtin.help_tags, { desc = "Telescope help tags" })
    -- vim.keymap.set("n", "g/k", builtin.keymaps, { desc = "Telescope keymaps" })
    -- vim.keymap.set("n", "g/q", builtin.quickfix, { desc = "Telescope Quickfix" })
    vim.keymap.set("n", "g/Q", builtin.quickfixhistory, { desc = "Telescope Quickfix hist" })

    require("telescope").setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            -- Map actions.which_key to <C-h> (default: <C/>)
            ["<C-h>"] = "which_key",
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q›"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      pickers = {
        -- Default configuration for builtin pickers
      },
      extensions = {
        -- Configuration for extensions
      },
    })

    -- Load any extensions you need
    require("telescope").load_extension("fzf")
    require("telescope").load_extension("scope")
    require("telescope").load_extension("rest")
  end,
}
