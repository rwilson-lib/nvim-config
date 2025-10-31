return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  root_dir = function(fname)
    return require("lspconfig").util.root_pattern(".git", ".marksman.toml")(fname) or vim.fn.getcwd()
  end,
}
