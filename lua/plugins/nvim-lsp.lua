return {
  -- https://lsp-zero.netlify.app/docs/guide/integrate-with-mason-nvim.html
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "mason-org/mason.nvim", opts = {} },
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      opts = { lsp = { auto_attach = true } },
    },
  },
  opts = {
    servers = {
      graphql = {
        filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      },
      emmet_ls = {
        filetypes = { "html", "css", "sass", "scss", "less", "typescriptreact", "javascriptreact", "svelte" },
      },
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
    -- local util = require("lspconfig.util")
    -- local navic = require("nvim-navic")
    --

    -- config = function()
    --   local on_attach = function(client, bufnr)
    --     if client.server_capabilities.documentSymbolProvider then
    --       navic.attach(client, bufnr)
    --     end
    --   end

    -- end,

    for server, config in pairs(opts.servers) do
      config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      lspconfig[server].setup(config)
    end

    -- Set diagnostic icons
    vim.diagnostic.config({
      virtual_text = true, --Enable vitual text
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
        local options = function(desc)
          desc = desc or "" --
          return { buffer = ev.buf, silent = true, desc = desc }
        end

        keymap("n", "gD", vim.lsp.buf.declaration, options("lsp declaration"))
        keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", options("Telescope lsp_definitions"))
        keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", options("Telescope lsp_references"))
        keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", options("Telescope lsp_implementations"))
        keymap("n", "K", vim.lsp.buf.hover, options("Popup Docs"))
        keymap("n", "g=", vim.lsp.buf.format, options("lsp format"))

        keymap("n", "<leader>lcd", "<cmd>Telescope diagnostics<CR>", options("Telescope lsp ws diag"))
        keymap("n", "g/S", "<cmd>Telescope lsp_workspace_symbols<CR>", options("Telescope lsp ws sym"))
        keymap("n", "g/s", "<cmd>Telescope lsp_document_symbols<CR>", options("Telescope lsp sym"))

        keymap("n", "<leader>lch", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
        end, options("[T]oggle Inlay [H]ints"))
      end,
    })
  end,
}
