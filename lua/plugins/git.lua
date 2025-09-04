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
          local function nav_next()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end

          local function nav_prev()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end

          map("n", "]c", nav_next, { desc = "Gitsigns next hunk" })
          map("n", "[c", nav_prev, { desc = "Gitsigns prev hunk" })
          --
          -- Actions
          map("n", "<localleader>gS", gitsigns.stage_buffer, { desc = "Gitsigns stage buf hunk" })
          map("n", "<localleader>gR", gitsigns.reset_buffer, { desc = "Gitsigns reset buf hunk" })

          map("v", "<localleader>gs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Gitsigns stage hunk" })

          map("v", "<localleader>gr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Gitsigns reset hunk" })

          map("n", "<localleader>gpp", gitsigns.preview_hunk, { desc = "Gitsigns preview hunk" })
          map("n", "<localleader>gpi", gitsigns.preview_hunk_inline, { desc = "Gitsigns preview hunk inline" })

          map("n", "<localleader>gb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Gitsigns blame" })

          map("n", "<localleader>gd", gitsigns.diffthis, { desc = "Gitsigns show diff" })

          map("n", "<localleader>gD", function()
            gitsigns.diffthis("~")
          end, { desc = "Gitsigns show diff" })

          map("n", "<localleader>gQ", function()
            gitsigns.setqflist("all")
          end, { desc = "Gitsigns quickfix all" })
          map("n", "<localleader>gq", gitsigns.setqflist, { desc = "Gitsigns quickfix list" })
          map("n", "<localleader>gcc", "<cmd>Neogit commit<cr>", { desc = "Gitsigns commit" })
          map("n", "<localleader>gcC", "<cmd>Neogit<cr>", { desc = "Gitsigns Neogit" })

          -- Toggles
          map("n", "<localleader>gtb", gitsigns.toggle_current_line_blame, { desc = "Gitsigns toggle inline blame" })
          map("n", "<localleader>gtw", gitsigns.toggle_word_diff, { desc = "Gitsigns toggle word diff" })

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
      require("neogit").setup({
        kind = "tab",
        commit_editor = {
          kind = "tab",
          show_staged_diff = true,
          staged_diff_split_kind = "vsplit",
          spell_check = true,
        },

        integrations = {
          snacks = true,
        },

        mappings = {
          commit_editor = {
            ["q"] = "Close",
            ["<c-c><c-c>"] = "Submit",
            ["<c-c><c-k>"] = "Abort",
            ["<m-p>"] = "PrevMessage",
            ["<m-n>"] = "NextMessage",
            ["<m-r>"] = "ResetMessage",
          },
          commit_editor_I = {
            ["<c-c><c-c>"] = "Submit",
            ["<c-c><c-k>"] = "Abort",
          },
        },
      })
    end,
  },
  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    version = "*",
    dependencies = {
      {
        "yorickpeterse/nvim-pqf",
        config = function()
          require("pqf").setup()
        end,
      },
    },
    config = function()
      require("git-conflict").setup()
    end,
  },
}
--
-- local msg = string.format(
--   [[You are an expert at following the Conventional Commit specification. Given the git diff listed below, please generate a commit message for me:
--
-- ```diff
-- %s
-- ```
-- ]],
--   vim.fn.system("git diff --no-ext-diff --staged")
-- )
--
