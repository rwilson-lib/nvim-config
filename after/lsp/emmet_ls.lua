return {
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
}
