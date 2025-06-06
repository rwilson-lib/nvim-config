return {
  -- https://lsp-zero.netlify.app/docs/guide/integrate-with-mason-nvim.html
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
	{ "folke/neodev.nvim", opts = {} },
      },
  config = function()
    local lspconfig = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local util = require("lspconfig.util")

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Set diagnostic icons
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl })
    end

    vim.diagnostic.config({ virtual_text = true })

    -- Global LspAttach autocmd
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local keymap = vim.keymap.set

        keymap("n", "gD", vim.lsp.buf.declaration, opts)
        keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
        keymap("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
        keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
        keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
        keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
        keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
        keymap("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
        keymap("n", "<leader>d", vim.diagnostic.open_float, opts)
        keymap("n", "K", vim.lsp.buf.hover, opts)
        keymap("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
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
              diagnostics = {
                globals = { "vim" }
              },
              completion = { callSnippet = "Replace" },
            },
          },
        })
      end,
    }



     require('mason-lspconfig').setup({
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
          lua_ls = custom_handlers.lua_ls()
        }
      })


    -- mason_lspconfig.setup_handlers(function(server_name)
    -- if custom_handlers[server_name] then
    --    custom_handlers[server_name]()
    -- else
    --    lspconfig[server_name].setup({
     --     capabilities = capabilities,
     --   })
     -- end
   -- end)
  end,
}
