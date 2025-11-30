-- https://deepwiki.com/folke/snacks.nvim/2.6-actions-and-keymaps
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      terminal = {
        true, -- This enables snacks.terminal
      },
      animation = {
        enabled = true,
      },
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      image = {
        enabled = true,
        doc = { float = false },
      },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      picker = {
        enabled = true,
        gh = {
          enable = true, -- ✅ this turns on all the gh pickers
        },
        layouts = {
          custom = {
            layout = {
              box = "vertical",
              backdrop = false,
              row = -1,
              width = 0,
              height = 0.4,
              border = "top",
              title = " {title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list", border = "none" },
                { win = "preview", title = "{preview}", width = 0.6, border = "left" },
              },
            },
          },
        },
        layout = { preset = "telescope", circle = true },
        actions = {
          my_custom_action = function(picker, item)
            -- Hide picker while selecting window
            if not picker.layout.split then
              picker.layout:hide()
            end

            local win = Snacks.picker.util.pick_win({ main = picker.main })

            if win then
              picker.main = win
              local buf = item.buf
              local pos = item.pos
              local lnum = (pos and pos[1]) or 1
              local col = (pos and pos[2]) or 1
              -- Open in selected window

              if item.file then
                -- vim.api.nvim_set_current_win(win)
                buf = vim.fn.bufadd(item.file)
                vim.fn.bufload(buf)
                -- Make it appear in :ls
                vim.bo[buf].buflisted = true
                -- Keep it hidden (won't force a window)
                vim.bo[buf].bufhidden = "hide"
              end
              -- vim.api.nvim_win_set_cursor(win, { lnum, col })
              require("dap.breakpoints").toggle(nil, buf, lnum)

              -- for key, value in pairs(item) do
              --   print("Key:", key, "Value:", value)
              -- end
            end

            -- Restore picker
            if not picker.layout.split then
              picker.layout:unhide()
            end
          end,
        },
        sources = {
          lines = {
            win = {
              input = {
                keys = {
                  ["<C-b>"] = { "my_custom_action", mode = { "n", "i" } },
                },
              },
            },
          },
          lsp_workspace_symbols = {
            layout = "custom",
            win = {
              input = {
                keys = {
                  ["<C-b>"] = { "my_custom_action", mode = { "n", "i" } },
                },
              },
            },
          },
          lsp_symbols = {
            layout = "custom",
            win = {
              input = {
                keys = {
                  ["<C-b>"] = { "my_custom_action", mode = { "n", "i" } },
                },
              },
            },
          },
          grep = { layout = "custom" },
        },
        win = {
          input = {
            keys = {
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["J"] = { "preview_scroll_down", mode = { "n", "i" } },
              ["K"] = { "preview_scroll_up", mode = { "n", "i" } },
              ["H"] = { "preview_scroll_left", mode = { "n", "i" } },
              ["L"] = { "preview_scroll_right", mode = { "n", "i" } },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          -- wo = { wrap = true } -- Wrap notifications
        },
      },
      zen = {
        enabled = true,
        window = "current",
      },
    },

  -- stylua: ignore
  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files", },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers", },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep", },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History", },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History", },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer", },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers", },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File", },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files", },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files", },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent", },
    -- { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects", },
    -- gh
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches", },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log", },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line", },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status", },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash", },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)", },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File", },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers", },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep", },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" }, },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers", },
    { "<leader>s/", function() Snacks.picker.search_history() end, desc = "Search History", },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds", },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines", },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History", },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands", },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics", },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics", },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages", },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights", },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons", },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps", },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps", },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List", },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks", },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages", },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec", },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List", },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume", },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History", },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes", },
    -- Other
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode", },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom", },
    { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer", },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer", },
    { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History", },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer", },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File", },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" }, },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit", },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications", },
    { "<c-/>", function() Snacks.terminal() end, mode = { "n", "t", "i" }, desc = "Toggle Terminal", },
    { "<leader>ot", function() Snacks.terminal() end, desc = "which_key_ignore", },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" }, },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" }, },
    { "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    },
  },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.line_number():map("<leader>uL")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>ul")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
