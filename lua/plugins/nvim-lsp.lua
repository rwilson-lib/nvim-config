return {
  -- https://lsp-zero.netlify.app/docs/guide/integrate-with-mason-nvim.html
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    { "mason-org/mason.nvim",                opts = {} },
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim",                   opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local util = require("lspconfig.util")

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Set diagnostic icons
    vim.diagnostic.config({
      virtual_text = true, --Enable vitual text
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN]  = " ",
          [vim.diagnostic.severity.HINT]  = "󰠠 ",
          [vim.diagnostic.severity.INFO]  = " ",
        },
      },
    })

    -- Global LspAttach autocmd
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local keymap = vim.keymap.set
        local opts = function(desc)
          desc = desc or "" --
          return { buffer = ev.buf, silent = true, desc = desc }
        end

        keymap("n", "gD", vim.lsp.buf.declaration, opts("lsp declaration"))
        keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts("Telescope lsp_definitions"))
        keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts("Telescope lsp_references"))
        keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts("Telescope lsp_implementations"))
        keymap("n", "K", vim.lsp.buf.hover, opts("Popup Docs"))
        keymap("n", "g=", vim.lsp.buf.format, opts("lsp format"))

        keymap("n", "<leader>lcd", "<cmd>Telescope diagnostics<CR>", opts("Telescope lsp ws diag"))
        keymap('n', 'g/S', "<cmd>Telescope lsp_workspace_symbols<CR>", opts("Telescope lsp ws sym"))
        keymap('n', 'g/s', "<cmd>Telescope lsp_document_symbols<CR>", opts("Telescope lsp sym"))

        keymap("n", '<leader>lch',
          function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, opts("[T]oggle Inlay [H]ints"))
      end,
    })

    -- Handler map
    local custom_handlers = {
      svelte = function()
        lspconfig.svelte.setup({
          capabilities = capabilities,
          on_attach = function(client)
            vim.api.nvim_create_autocmd("BufWritePost", {
              pattern = { "*.js", "*.ts" },
              callback = function(ctx)
                local uri = vim.uri_from_fname(ctx.file)
                client.notify("$/onDidChangeTsOrJsFile", { uri = uri })
              end,
            })
          end,
        })
      end,

      gopls = function()
        lspconfig.gopls.setup({
          -- on_attach = on_attach
          cmd = { "gopls" },
          capabilities = capabilities,
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_dir = util.root_pattern("go.work", "go.mod", ".git"),
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              semanticTokens = true,
              staticcheck = true,
              analyses = { unusedparams = true },
            },
          },
        })
      end,

      graphql = function()
        lspconfig.graphql.setup({
          capabilities = capabilities,
          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
        })
      end,

      emmet_ls = function()
        lspconfig.emmet_ls.setup({
          capabilities = capabilities,
          filetypes = {
            "html", "css", "sass", "scss", "less",
            "typescriptreact", "javascriptreact", "svelte",
          },
        })
      end,

      lua_ls = function()
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              runtime = {
                version = 'LuaJIT'
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
                globals = { "vim" }
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = true,
              },
              completion = { callSnippet = "Replace" },
            },
          },
        })
      end,
    }

    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls', 'gopls',
        -- add other servers here
      },
      automatic_enable = true,
      handlers = {
        -- this first function is the "default handler"
        -- it applies to every language server without a "custom handler"
        function(server_name)
          require('lspconfig')[server_name].setup({})
        end,
        custom_handlers,
      }
    })
  end,
}
