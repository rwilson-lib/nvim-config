return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",
    "nvim-neotest/neotest-jest",
  },
  opts = {},
  config = function()
    vim.api.nvim_set_keymap(
      "n",
      "<leader>tw",
      "<cmd>lua require('neotest').run.run({ jestCommand = 'jest --watch ' })<cr>",
      {}
    )
    -- get neotest namespace (api call creates or returns namespace)
    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

    require("neotest").setup({
      log_level = "DEBUG",
      adapters = {
        require("neotest-go")({
          experimental = {
            test_table = true,
            coverage = true, -- 🔧 must be enabled
          },
        }),
        require("neotest-jest")({
          -- Command to run Jest
          jestCommand = "npx jest",
          -- Path to your Jest config
          jestConfigFile = "jest.config.js",
          -- Environment for CI mode
          env = { CI = true },
          -- Optional: run only current file by default
          cwd = function(path)
            return vim.fn.getcwd()
          end,
        }),
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      quickfix = {
        open = true,
        enabled = true,
      },
    })
  end,
}
