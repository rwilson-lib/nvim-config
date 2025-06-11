return {
  "kndndrj/nvim-dbee",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  build = function()
    -- Install tries to automatically detect the install method.
    -- if it fails, try calling it with one of these parameters:
    --    "curl", "wget", "bitsadmin", "go"
    require("dbee").install()
  end,
  config = function()
    require("dbee").setup({
      drawer = {
        disable_help = false,
        -- mappings for the buffer
        mappings = {
          -- manually refresh drawer
          { key = "r", mode = "n", action = "refresh" },
          -- actions perform different stuff depending on the node:
          -- action_1 opens a note or executes a helper
          { key = "<CR>", mode = "n", action = "action_1" },
          -- action_2 renames a note or sets the connection as active manually
          { key = "cw", mode = "n", action = "action_2" },
          -- action_3 deletes a note or connection (removes connection from the file if you configured it like so)
          { key = "dd", mode = "n", action = "action_3" },
          -- these are self-explanatory:
          -- { key = "c", mode = "n", action = "collapse" },
          -- { key = "e", mode = "n", action = "expand" },
          { key = "o", mode = "n", action = "toggle" },
          { key = "<Tab>", mode = "n", action = "toggle" },
          -- mappings for menu popups:
          { key = "<CR>", mode = "n", action = "menu_confirm" },
          { key = "y", mode = "n", action = "menu_yank" },
          { key = "<Esc>", mode = "n", action = "menu_close" },
          { key = "q", mode = "n", action = "menu_close" },
        },
      },
      -- results window config
      result = {
        -- number of rows in the results set to display per page
        page_size = 100,

        -- whether to focus the result window after a query
        focus_result = false,

        -- mappings for the buffer
        mappings = {
          -- next/previous page
          { key = "L", mode = "", action = "page_next" },
          { key = "H", mode = "", action = "page_prev" },
          { key = "E", mode = "", action = "page_last" },
          { key = "F", mode = "", action = "page_first" },
          -- yank rows as csv/json
          { key = "yaj", mode = "n", action = "yank_current_json" },
          { key = "yaj", mode = "v", action = "yank_selection_json" },
          { key = "yaJ", mode = "", action = "yank_all_json" },
          { key = "yac", mode = "n", action = "yank_current_csv" },
          { key = "yac", mode = "v", action = "yank_selection_csv" },
          { key = "yaC", mode = "", action = "yank_all_csv" },

          -- cancel current call execution
          { key = "<C-c>", mode = "", action = "cancel_call" },
        },
      },
      -- editor window config
      editor = {
        -- see drawer comment.
        window_options = {},
        buffer_options = {},

        -- directory where to store the scratchpads.
        --directory = "path/to/scratchpad/dir",

        -- mappings for the buffer
        mappings = {
          -- run what's currently selected on the active connection
          { key = "BB", mode = "v", action = "run_selection" },
          -- run the whole file on the active connection
          { key = "BB", mode = "n", action = "run_file" },
        },
      },
    })
  end,
}
