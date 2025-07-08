return {
  "mason-org/mason.nvim",
  dependencies = {
    "mason-org/mason-lspconfig.nvim",
    "jay-babu/mason-null-ls.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- import mason
    local mason = require("mason")

    -- import mason-lspconfig
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")
    local mason_null_ls = require("mason-null-ls")
    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "lua_ls",
        "emmet_ls",
        "html",
        "gopls",
      },
      automatic_installation = true,
      automatic_enable = false,
    })
    --
    -- 1. mason-null-ls.nvim setup to auto-install pgformatter
    mason_null_ls.setup({
      ensure_installed = {
        "goimports", -- Go formatter (gopls will often use this)
        "pgformatter",
        "stylua",
      },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "prettier", -- prettier formatter
        "stylua", -- lua formatter
        "isort", -- python formatter
        "black", -- python formatter
        "pylint",
        "eslint_d",
        "delve", -- ✅ Go debugger
      },
    })
  end,
}
