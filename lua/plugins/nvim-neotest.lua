return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
  },
  opts = {},
  config = function()
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message =
              diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

    require("neotest").setup({
      adapters = {
        require("neotest-go")({
          experimental = {
            test_table = true,
            coverage = true, -- 🔧 must be enabled
          },
        }),
      },
      output_panel = {
        enabled = true,
        open = 'botright split | resize 15',
      },
      quickfix = {
        open = false,
      },
    })
  end
}
