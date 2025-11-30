Snacks = Snacks or {}
return {
  {
    "numToStr/Comment.nvim",
    opts = {},
  },
  {
    -- Then type <c-y>, (Ctrl-y,), and you should see:
    "mattn/emmet-vim",
    ft = { "html", "css", "javascriptreact", "typescriptreact" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-;>" -- or any key you like
      vim.g.user_emmet_mode = "inv" -- or any key you like
      vim.g.user_emmet_install_global = 0
      vim.cmd([[ autocmd FileType html,css,javascriptreact,typescriptreact EmmetInstall ]])
    end,
  },
  {
    -- https://lsp-zero.netlify.app/docs/guide/integrate-with-mason-nvim.html
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- "hrsh7th/cmp-nvim-lsp",
      { "mason-org/mason.nvim", opts = {} },
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
      { "SmiteshP/nvim-navbuddy", opts = { lsp = { auto_attach = true } } },
      { "MunifTanjim/nui.nvim" },
      {
        "SmiteshP/nvim-navic",
        config = function()
          require("nvim-navic").setup({
            lsp = { auto_attach = true, preference = nil },
            click = true,
          })
        end,
      },
    },

    config = function()
      local servers = {
        "lua_ls",
        "emmet_ls",
        "html",
        "gopls",
        "marksman",
        "ts_ls",
        "cssls",
        "eslint",
        "html",
        "jsonls",
        "tailwindcss",
        "graphql",
        "basedpyright",
      }

      vim.lsp.enable(servers)

      vim.diagnostic.config({
        virtual_text = true, --Enable vitual text
        virtual_lines = {
          current_line = true, -- show on all lines or just the cursor line
        },
        underline = true,
        -- Set diagnostic icons
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      -- Global LspAttach autocmd
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local keymap = vim.keymap.set
          ---@param desc string|nil
          ---@param nowait boolean|nil
          ---@return table
          local options = function(desc, nowait)
            desc = desc or "" --
            nowait = nowait or false --
            return { buffer = ev.buf, silent = true, nowait = nowait, desc = desc }
          end

          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client.server_capabilities.documentSymbolProvider then
            -- set winbar to nvim-navic in the local buf
            local win = vim.fn.bufwinid(ev.buf)
            if win ~= -1 then
              vim.api.nvim_set_option_value("winbar", "%{%v:lua.require'nvim-navic'.get_location()%}", { win = win })
            end
          end

          keymap("n", "gD", function()
            Snacks.picker.lsp_declarations()
          end, options("Goto Declaration"))
          keymap("n", "gd", function()
            Snacks.picker.lsp_definitions()
          end, options("Goto Definition"))
          keymap("n", "gR", function()
            Snacks.picker.lsp_references()
          end, options("References", true))
          keymap("n", "gI", function()
            Snacks.picker.lsp_implementations()
          end, options("Goto Implementation"))
          keymap("n", "gy", function()
            Snacks.picker.lsp_type_definitions()
          end, options("Goto t[y]pe Definition"))
          keymap("n", "K", vim.lsp.buf.hover, options("Popup Docs"))
          keymap("n", "g=", vim.lsp.buf.format, options("lsp format"))

          keymap("n", "<leader>lcd", "<cmd>Telescope diagnostics<CR>", options("Telescope lsp ws diag"))
          keymap("n", "<leader>ss", function()
            Snacks.picker.lsp_symbols()
          end, options("LSP Symbols"))
          keymap("n", "<leader>sS", function()
            Snacks.picker.lsp_workspace_symbols()
          end, options("LSP Workspace Symbols"))

          keymap("n", "<leader>lch", function()
            Snacks.toggle.inlay_hints()
          end, options("[T]oggle Inlay [H]ints"))
        end,
      })
    end,
  },
}
