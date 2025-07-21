-- Decrypt API key and set it as an environment variable
local gemini_api_key = vim.fn.system("bash -c 'gpg --batch --quiet --decrypt ~/gemini_api_key.gpg' | tr -d '\n'")
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
  {
    "Davidyz/VectorCode",
    build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
    -- build = "pipx upgrade vectorcode", -- If you used pipx to install the CLI
    dependencies = { "nvim-lua/plenary.nvim" },
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
      "ravitemer/codecompanion-history.nvim",
    },

    init = function()
      require("utils.fidget-spinner"):init()
    end,

    config = function()
      require("codecompanion").setup({
        opts = {
          -- Set debug logging
          -- log_level = "DEBUG",
        },
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
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true, -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            },
          },

          history = {
            enabled = true,
            opts = {
              -- Keymap to open history from chat buffer (default: gh)
              keymap = "gh",
              -- Keymap to save the current chat manually (when auto_save is disabled)
              save_chat_keymap = "sc",
              -- Save all chats by default (disable to save only manually using 'sc')
              auto_save = true,
              -- Number of days after which chats are automatically deleted (0 to disable)
              expiration_days = 0,
              -- Picker interface (auto resolved to a valid picker)
              picker = "snacks", --- ("telescope", "snacks", "fzf-lua", or "default")
              ---Optional filter function to control which chats are shown when browsing
              chat_filter = nil, -- function(chat_data) return boolean end
              -- Customize picker keymaps (optional)
              picker_keymaps = {
                rename = { n = "r", i = "<M-r>" },
                delete = { n = "d", i = "<M-d>" },
                duplicate = { n = "<C-y>", i = "<C-y>" },
              },
              ---Automatically generate titles for new chats
              auto_generate_title = true,
              title_generation_opts = {
                ---Adapter for generating titles (defaults to current chat adapter)
                adapter = nil, -- "copilot"
                ---Model for generating titles (defaults to current chat model)
                model = nil, -- "gpt-4o"
                ---Number of user prompts after which to refresh the title (0 to disable)
                refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
                ---Maximum number of times to refresh the title (default: 3)
                max_refreshes = 3,
                format_title = function(original_title)
                  -- this can be a custom function that applies some custom
                  -- formatting to the title.
                  return original_title
                end,
              },
              ---On exiting and entering neovim, loads the last chat on opening chat
              continue_last_chat = false,
              ---When chat is cleared with `gx` delete the chat from history
              delete_on_clearing_chat = false,
              ---Directory path to save the chats
              dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
              ---Enable detailed logging for history extension
              enable_logging = false,

              -- Summary system
              summary = {
                -- Keymap to generate summary for current chat (default: "gcs")
                create_summary_keymap = "gcs",
                -- Keymap to browse summaries (default: "gbs")
                browse_summaries_keymap = "gbs",

                generation_opts = {
                  adapter = nil, -- defaults to current chat adapter
                  model = nil, -- defaults to current chat model
                  context_size = 90000, -- max tokens that the model supports
                  include_references = true, -- include slash command content
                  include_tool_outputs = true, -- include tool execution results
                  system_prompt = nil, -- custom system prompt (string or function)
                  format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
                },
              },

              -- Memory system (requires VectorCode CLI)
              memory = {
                -- Automatically index summaries when they are generated
                auto_create_memories_on_summary_generation = true,
                -- Path to the VectorCode executable
                vectorcode_exe = "vectorcode",
                -- Tool configuration
                tool_opts = {
                  -- Default number of memories to retrieve
                  default_num = 10,
                },
                -- Enable notifications for indexing progress
                notify = true,
                -- Index all existing memories on startup
                -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
                index_on_startup = false,
              },
            },
          },
        },
        adapters = {
          gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
              env = {
                api_key = gemini_api_key,
              },
            })
          end,
        },
      })
    end,
  },
  -- https://github.com/yetone/avante.nvim/blob/main/lua/avante/config.lua
  -- {
  --   "yetone/avante.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --     --- The below dependencies are optional,
  --     -- "echasnovski/mini.pick", -- for file_selector provider mini.pic
  --     "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
  --     "folke/snacks.nvim", -- for input provider snacks
  --     -- "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
  --     -- "ibhagwan/fzf-lua", -- for file_selector provider fzf
  --     -- "stevearc/dressing.nvim", -- for input provider dressing
  --     -- "zbirenbaum/copilot.lua", -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       "HakonHarnes/img-clip.nvim",
  --       event = "VeryLazy",
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --           -- required for Windows users
  --           use_absolute_path = true,
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --   },
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   -- ⚠️ must add this setting! ! !
  --   build = function()
  --     -- conditionally use the correct build system for the current OS
  --     if vim.fn.has("win32") == 1 then
  --       return "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
  --     else
  --       return "make"
  --     end
  --   end,
  --   event = "VeryLazy",
  --   config = function()
  --     vim.fn.setenv("AVANTE_GEMINI_API_KEY", gemini_api_key)
  --     require("avante").setup({
  --       -- system_prompt as function ensures LLM always has latest MCP server state
  --       -- This is evaluated for every message, even in existing chats
  --       provider = "gemini",
  --       providers = {
  --         gemini = {
  --           endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
  --           model = "gemini-2.0-flash",
  --           timeout = 30000, -- Timeout in milliseconds
  --           context_window = 1048576,
  --           use_ReAct_prompt = true,
  --           extra_request_body = {
  --             generationConfig = {
  --               temperature = 0.75,
  --             },
  --           },
  --         },
  --       },
  --       behaviour = {
  --         enable_token_counting = false,
  --       },
  --       windows = {
  --         ---@alias AvantePosition "right" | "left" | "top" | "bottom" | "smart"
  --         ---@type AvantePosition
  --         position = "right",
  --         fillchars = "eob: ",
  --         wrap = true, -- similar to vim.o.wrap
  --         width = 30, -- default % based on available width in vertical layout
  --         height = 30, -- default % based on available height in horizontal layout
  --         sidebar_header = {
  --           enabled = true, -- true, false to enable/disable the header
  --           align = "center", -- left, center, right for title
  --           rounded = true,
  --         },
  --         input = {
  --           prefix = "> ",
  --           height = 10, -- Height of the input window in vertical layout
  --         },
  --         edit = {
  --           border = { " ", " ", " ", " ", " ", " ", " ", " " },
  --           start_insert = true, -- Start insert mode when opening the edit window
  --         },
  --         ask = {
  --           floating = true, -- Open the 'AvanteAsk' prompt in a floating window
  --           border = { " ", " ", " ", " ", " ", " ", " ", " " },
  --           start_insert = true, -- Start insert mode when opening the ask window
  --           ---@alias AvanteInitialDiff "ours" | "theirs"
  --           ---@type AvanteInitialDiff
  --           focus_on_apply = "ours", -- which diff to focus after applying
  --         },
  --       },
  --       system_prompt = function()
  --         local hub = require("mcphub").get_hub_instance()
  --         return hub and hub:get_active_servers_prompt() or ""
  --       end,
  --
  --       -- Using function prevents requiring mcphub before it's loaded
  --       custom_tools = function()
  --         return {
  --           require("mcphub.extensions.avante").mcp_tool(),
  --         }
  --       end,
  --     })
  --   end,
  -- },
}
