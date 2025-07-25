return {
  "andythigpen/nvim-coverage",
  config = function()
    require("coverage").setup({
      auto_reload = true,
      commands = true,

      highlights = {
        -- customize highlight groups created by the plugin
        covered = { fg = "#C3E88D" }, -- supports style, fg, bg, sp (see :h highlight-gui)
        uncovered = { fg = "#F07178" },
      },
      signs = {
        -- use your own highlight groups or text markers
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
      },

      summary = {
        -- customize the summary pop-up
        min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
      },

      load_coverage_cb = function(ftype)
        vim.notify("Loaded " .. ftype .. " coverage")
      end,
    })
  end,
}
