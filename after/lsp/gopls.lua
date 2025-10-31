return {
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      semanticTokens = true,
      staticcheck = true,
      analyses = { unusedparams = true },
    },
  },
}
