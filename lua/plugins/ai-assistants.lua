-- Decrypt API key and set it as an environment variable
local gemini_api_key = vim.fn.system("bash -c 'gpg --batch --quiet --decrypt ~/gemini_api_key.gpg'")
gemini_api_key = gemini_api_key:gsub("^%s*(.-)%s*$", "%1") -- Trim leading/trailing whitespace
return {
  {
    "NickvanDyke/opencode.nvim",
    dependencies = {
      -- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
      { "folke/snacks.nvim", opts = { input = { enabled = true } } },
    },
    config = function()
      -- `opencode.nvim` passes options via a global variable instead of `setup()` for faster startup
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any — see `lua/opencode/config.lua`
      }

      -- Required for `opts.auto_reload`
      vim.opt.autoread = true

      -- Recommended keymaps
      vim.keymap.set("n", "<leader>aot", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })
      vim.keymap.set("n", "<leader>aoA", function()
        require("opencode").ask()
      end, { desc = "Ask opencode" })
      vim.keymap.set("n", "<leader>aoa", function()
        require("opencode").ask("@cursor: ")
      end, { desc = "Ask opencode about this" })
      vim.keymap.set("v", "<leader>aoa", function()
        require("opencode").ask("@selection: ")
      end, { desc = "Ask opencode about selection" })
      vim.keymap.set("n", "<leader>aon", function()
        require("opencode").command("session_new")
      end, { desc = "New opencode session" })
      vim.keymap.set("n", "<leader>aoy", function()
        require("opencode").command("messages_copy")
      end, { desc = "Copy last opencode response" })
      vim.keymap.set("n", "<S-C-u>", function()
        require("opencode").command("messages_half_page_up")
      end, { desc = "Messages half page up" })
      vim.keymap.set("n", "<S-C-d>", function()
        require("opencode").command("messages_half_page_down")
      end, { desc = "Messages half page down" })
      vim.keymap.set({ "n", "v" }, "<leader>aos", function()
        require("opencode").select()
      end, { desc = "Select opencode prompt" })

      -- Example: keymap for custom prompt
      vim.keymap.set("n", "<leader>aoe", function()
        require("opencode").prompt("Explain @cursor and its context")
      end, { desc = "Explain this code" })
    end,
  },
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
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
    },
    keys = {
      { "<leader>aca", "<cmd>CodeCompanion<CR>", mode = { "n", "v" }, desc = "CodeCompanion" },
      { "<leader>acc", "<cmd>CodeCompanionChat<CR>", mode = { "n", "v" }, desc = "Companion Chat" },
      { "<leader>ax", "<cmd>CodeCompanionCmd<CR>", mode = { "n", "v" }, desc = "Companion Cmd" },
      { "<leader>as", "<cmd>CodeCompanionActions<CR>", mode = { "n", "v" }, desc = "Companion Actions" },
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
      vim.cmd.cnoreabbrev("CC CodeCompanion")
      require("utils.fidget-spinner"):init()
    end,

    config = function()
      require("codecompanion").setup({
        opts = {
          -- Set debug logging
          -- log_level = "DEBUG",
        },
        prompt_library = {
          ["Commit Message"] = {
            strategy = "chat",
            description = "Generate a Conventional Commit message from staged changes",
            opts = {
              modes = { "n", "i" },
              short_name = "gcm",
              auto_submit = true,
              stop_context_insertion = true,
              user_prompt = false, -- fully automated, no extra user input needed
              placement = "add", -- or "replace"|"add"|"before"|"chat"

              -- pre_hook = function()
              --   local bufnr = vim.api.nvim_create_buf(true, false)
              --   vim.api.nvim_set_current_buf(bufnr)
              --   vim.api.nvim_set_option_value("filetype", "gitcommit", { buf = bufnr })
              --   return bufnr
              -- end,
            },
            prompts = {
              {
                role = "system",
                content = "You are an expert at writing commit messages following the Conventional Commit specification.",
              },
              {
                role = "user",
                content = function()
                  local diff = vim.fn.system("git diff --no-ext-diff --staged")

                  return string.format(
                    [[Given the staged git diff below, generate a clear and concise Conventional Commit message:
Strict requirements:
- Output ONLY the commit message, nothing else (no explanations, no markdown, no formatting).
- The message must follow the Conventional Commit specification.
- Use type(scope): subject structure.
- Keep the subject under 72 characters.
- Add a body if needed for clarity, wrapped at 72 characters per line.
- If there is a breaking change, add a "BREAKING CHANGE:" footer describing it.
- Do not include code snippets, commentary, or extra text.
```diff
%s
```]],
                    diff
                  )
                end,
              },
            },
          },
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
          http = {
            gemini = function()
              return require("codecompanion.adapters").extend("gemini", {
                env = {
                  api_key = gemini_api_key,
                },
              })
            end,
          },
        },
      })
    end,
  },
}
