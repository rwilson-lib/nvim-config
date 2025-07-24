return {
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signs_staged_enable = true,
        signcolumn = false, -- Toggle with `:Gitsigns toggle_signs`
        numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options passed to nvim_open_win
          border = "single",
          style = "minimal",
          relative = "cursor",
          row = 0,
          col = 1,
        },
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Gitsigns next hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Gitsigns prev hunk" })

          -- Actions
          map("n", ";gs", gitsigns.stage_hunk, { desc = "Gitsigns stage hunk" })
          map("n", ";gr", gitsigns.reset_hunk, { desc = "Gitsigns reset hunk" })
          map("n", ";gS", gitsigns.stage_buffer, { desc = "Gitsigns stage buf hunk" })
          map("n", ";gR", gitsigns.reset_buffer, { desc = "Gitsigns reset buf hunk" })

          map("v", ";gs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Gitsigns stage hunk" })

          map("v", ";gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Gitsigns reset hunk" })

          map("n", ";gpp", gitsigns.preview_hunk, { desc = "Gitsigns preview hunk" })
          map("n", ";gpi", gitsigns.preview_hunk_inline, { desc = "Gitsigns preview hunk inline" })

          map("n", ";gb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Gitsigns blame" })

          map("n", ";gd", gitsigns.diffthis, { desc = "Gitsigns show diff" })

          map("n", ";gD", function()
            gitsigns.diffthis("~")
          end, { desc = "Gitsigns show diff" })

          map("n", ";gQ", function()
            gitsigns.setqflist("all")
          end, { desc = "Gitsigns quickfix all" })
          map("n", ";gq", gitsigns.setqflist, { desc = "Gitsigns quickfix list" })
          map("n", ";gcc", "<cmd>Neogit commit<cr>", { desc = "Gitsigns commit" })
          map("n", ";gcC", "<cmd>Neogit<cr>", { desc = "Gitsigns Neogit" })

          -- Toggles
          map("n", ";gtb", gitsigns.toggle_current_line_blame, { desc = "Gitsigns toggle inline blame" })
          map("n", ";gtw", gitsigns.toggle_word_diff, { desc = "Gitsigns toggle word diff" })

          -- Text object
          map({ "o", "x" }, "ih", gitsigns.select_hunk, { desc = "Gitsigns hunk text object" })
        end,
      })
    end,
  },
  {
    "NeogitOrg/neogit",
    cmd = "Neogit", -- lazy-load when :Neogit is run
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = function()
          require("diffview").setup({
            view = {
              default = {
                layout = "diff2_vertical",
              },
            },
          })
        end,
      },
      {
        "nvim-telescope/telescope.nvim", -- optional
        optional = true,
      },
    },
    config = function()
      require("lua.plugins.git").setup({
        kind = "tab",
        commit_popup = {
          kind = "vsplit",
        },
        preview_buffer = {
          kind = "floating",
        },
        integrations = {
          diffview = true,
        },
      })
    end,
  },
}
