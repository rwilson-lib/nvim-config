return {
  {
    "Exafunction/windsurf.vim",
    event = "BufEnter",
  },
  {
    -- https://www.youtube.com/watch?v=AUgbOckKxzw
    -- https://codecompanion.olimorris.dev
    "olimorris/codecompanion.nvim",
    cmd = {
      "CodeCompanion",
      "CodeCompanionActions",
      "CodeCompanionChat",
      "CodeCompanionCmd",
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "codecompanion", "markdown" },
      },
      "folke/fidget.nvim",
    },

    init = function()
      require("utils.fidget-spinner"):init()
    end,

    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "gemini",
          },
          inline = {
            adapter = "gemini",
            accept_change = {
              modes = { n = "ga" },
              description = "Accept the suggested change",
            },
            reject_change = {
              modes = { n = "gr" },
              description = "Reject the suggested change",
            },
          },
          cmd = {
            adapter = "gemini",
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              make_vars = true,
              make_slash_commands = true,
              show_result_in_chat = true,
            },
          },
        },

        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = "cmd: gpg --batch --quiet --decrypt ~/gemini_api_key.gpg",
              },
            })
          end,
        },
      })
    end,
  },
}
