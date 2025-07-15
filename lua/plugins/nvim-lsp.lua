return {
  {
    -- Then type <c-y>, (Ctrl-y,), and you should see:
    "mattn/emmet-vim",
    ft = { "html", "css", "javascriptreact", "typescriptreact" },
    init = function()
      vim.g.user_emmet_leader_key = "<C-y>" -- or any key you like
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
      "hrsh7th/cmp-nvim-lsp",
      { "mason-org/mason.nvim", opts = {} },
      { "antosha417/nvim-lsp-file-operations", config = true },
      { "folke/neodev.nvim", opts = {} },
      { "SmiteshP/nvim-navbuddy", opts = { lsp = { auto_attach = true } } },
      { "MunifTanjim/nui.nvim" },
      {
        "SmiteshP/nvim-navic",
        config = function()
          vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
          require("nvim-navic").setup({
            lsp = {
              auto_attach = true,
              preference = nil,
            },
            click = true,
          })
        end,
      },
    },
    opts = {
      servers = {
        clangd = {
          filetypes = { "c", "cpp" },
          cmd = { "clangd" },
        },
        gopls = {
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              semanticTokens = true,
              staticcheck = true,
              analyses = { unusedparams = true },
            },
          },
        },
        ts_ls = {},
        cssls = {},
        eslint = {},
        html = {},
        jsonls = {},
        tailwindcss = {},
        graphql = {},
        emmet_ls = {
          filetypes = {
            "html",
            "css",
            "scss",
            "javascriptreact",
            "typescriptreact",
            -- "jsx",
            -- "tsx",
          },
          settings = {
            emmet = {
              showExpandedAbbreviation = "always", -- Show preview of expanded snippet
              showAbbreviationSuggestions = true,
              showSuggestionsAsSnippets = true,
              syntaxProfiles = {
                jsx = { attr_quotes = "double", self_closing_tag = true },
                tsx = { attr_quotes = "double", self_closing_tag = true },
              },
              variables = {
                lang = "en",
              },
              preferences = {
                ["bem.enabled"] = false,
              },
              excludeLanguages = {},
            },
          },
        },
        lua_ls = {
          -- Server-specific settings. See `:help lsp-quickstart`
          settings = {
            lua_ls = {
              runtime = {
                version = "LuaJIT",
              },
              hint = {
                enable = true, -- ✅ enable inlay hints
                -- arrayIndex = "Auto",
                -- await = true,
                -- paramName = "All", -- Show parameter names
                -- paramType = true, -- Show parameter types
                -- semicolon = "Disable",
                -- setType = true, -- Show variable types
              },
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = true,
              },
              completion = { callSnippet = "Replace" },
            },
          },
        },
      },
    },

    config = function(_, opts)
      local lspconfig = require("lspconfig")
      Snacks = Snacks or {}
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      vim.diagnostic.config({
        virtual_text = true, --Enable vitual text
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

          -- local client = vim.lsp.get_client_by_id(ev.data.client_id)
          -- local navic = require("nvim-navic")
          -- if client.server_capabilities.documentSymbolProvider then
          --   navic.attach(client, ev.buf)
          -- end

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
