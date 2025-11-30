return {
  -- Server-specific settings. See `:help lsp-quickstart`
  settings = {
    Lua = {
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
        library = {
          vim.api.nvim_get_runtime_file("", true),
          "${3rd}/luassert/library",
        },
        checkThirdParty = true,
      },
      completion = { callSnippet = "Replace" },
    },
  },
}
