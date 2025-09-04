return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = true,
  opts = {
    disable_filetype = { "TelescopePrompt", "spectre_panel", "snacks_picker_input", "typr" },
  },
  -- this is equivalent to setup({}) function
}
