return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end,
  },
  { -- AI code suggestion
    "Exafunction/windsurf.vim",
    event = "BufEnter",
  },
  -- https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua
  {
    "yetone/avante.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      -- "echasnovski/mini.pick", -- for file_selector provider mini.pic
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "folke/snacks.nvim", -- for input provider snacks
      -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
      -- "stevearc/dressing.nvim", -- for input provider dressing
      -- "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    -- ⚠️ must add this setting! ! !
    build = function()
      -- conditionally use the correct build system for the current OS
      if vim.fn.has("win32") == 1 then
        return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      else
        return "make"
      end
    end,
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    config = function()
      -- Decrypt API key and set it as an environment variable
      local api_key = vim.fn.system("bash -c 'gpg --batch --quiet --decrypt ~/gemini_api_key.gpg' | tr -d '\n'")
      vim.fn.setenv("AVANTE_GEMINI_API_KEY", api_key)
      require("avante").setup({
        -- system_prompt as function ensures LLM always has latest MCP server state
        -- This is evaluated for every message, even in existing chats
        provider = "gemini",
        providers = {
          gemini = {
            endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
            model = "gemini-2.0-flash",
            timeout = 30000, -- Timeout in milliseconds
            context_window = 1048576,
            use_ReAct_prompt = true,
            extra_request_body = {
              generationConfig = {
                temperature = 0.75,
              },
            },
          },
        },
        behaviour = {
          enable_token_counting = false,
        },
        windows = {
          ---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
          ---@type AvantePosition
          position = "right",
          fillchars = "eob: ",
          wrap = true, -- similar to vim.o.wrap
          width = 30, -- default % based on available width in vertical layout
          height = 30, -- default % based on available height in horizontal layout
          sidebar_header = {
            enabled = true, -- true, false to enable/disable the header
            align = "center", -- left, center, right for title
            rounded = true,
          },
          input = {
            prefix = "> ",
            height = 10, -- Height of the input window in vertical layout
          },
          edit = {
            border = { " ", " ", " ", " ", " ", " ", " ", " " },
            start_insert = true, -- Start insert mode when opening the edit window
          },
          ask = {
            floating = true, -- Open the 'AvanteAsk' prompt in a floating window
            border = { " ", " ", " ", " ", " ", " ", " ", " " },
            start_insert = true, -- Start insert mode when opening the ask window
            ---@alias AvanteInitialDiff "ours" | "theirs"
            ---@type AvanteInitialDiff
            focus_on_apply = "ours", -- which diff to focus after applying
          },
        },
        system_prompt = function()
          local hub = require("mcphub").get_hub_instance()
          return hub and hub:get_active_servers_prompt() or ""
        end,

        -- Using function prevents requiring mcphub before it's loaded
        custom_tools = function()
          return {
            require("mcphub.extensions.avante").mcp_tool(),
          }
        end,
      })
    end,
  },
  -- {
  --   -- https://www.youtube.com/watch?v=AUgbOckKxzw
  --   -- https://codecompanion.olimorris.dev
  --   "olimorris/codecompanion.nvim",
  --   cmd = {
  --     "CodeCompanion",
  --     "CodeCompanionActions",
  --     "CodeCompanionChat",
  --     "CodeCompanionCmd",
  --   },
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "ravitemer/mcphub.nvim",
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       ft = { "codecompanion", "markdown" },
  --     },
  --     "folke/fidget.nvim",
  --   },
  --
  --   init = function()
  --     require("utils.fidget-spinner"):init()
  --   end,
  --
  --   config = function()
  --     require("codecompanion").setup({
  --       strategies = {
  --         chat = {
  --           adapter = "gemini",
  --         },
  --         inline = {
  --           adapter = "gemini",
  --           accept_change = {
  --             modes = { n = "ga" },
  --             description = "Accept the suggested change",
  --           },
  --           reject_change = {
  --             modes = { n = "gr" },
  --             description = "Reject the suggested change",
  --           },
  --         },
  --         cmd = {
  --           adapter = "gemini",
  --         },
  --       },
  --       extensions = {
  --         mcphub = {
  --           callback = "mcphub.extensions.codecompanion",
  --           opts = {
  --             show_result_in_chat = true, -- Show mcp tool results in chat
  --             make_vars = true, -- Convert resources to #variables
  --             make_slash_commands = true, -- Add prompts as /slash commands
  --           },
  --         },
  --       },
  --       adapters = {
  --         gemini = function()
  --           return require("codecompanion.adapters").extend("gemini", {
  --             env = {
  --               api_key = "cmd: gpg --batch --quiet --decrypt ~/gemini_api_key.gpg | tr -t '\n'",
  --             },
  --           })
  --         end,
  --       },
  --     })
  --   end,
  -- },
}
