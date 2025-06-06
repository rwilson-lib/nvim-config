
return {
  'nvim-treesitter/nvim-treesitter',
  run = ':TSUpdate',  -- Automatically update treesitter parsers after installation
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = { "lua", "javascript", "go" },  -- Add any additional languages you need
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,               -- Enable highlighting based on Treesitter
      },
      indent = {
        enable = true,               -- Enable indentation based on Treesitter
      },
    }
  end
}
