return {
  settings = {
    gopls = {
      hints = {
        rangeVariableTypes = true,
        parameterNames = true,
        constantValues = true,
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        functionTypeParameters = true,
        variableTypes = true,
      },
      completeUnimported = true,
      usePlaceholders = true,
      semanticTokens = true,
      staticcheck = true,
      analyses = { unusedparams = true },
    },
  },
}
