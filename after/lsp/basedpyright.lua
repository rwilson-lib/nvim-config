return {
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "strict", -- or "basic"
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        inlayHints = {
          variableTypes = true, -- show variable type hints
          functionReturnTypes = true, -- show function return type hints
          parameterNames = true, -- show parameter name hints in function calls
          callArgumentTypes = true, -- show argument types in calls
        },
      },
    },
  },
}
