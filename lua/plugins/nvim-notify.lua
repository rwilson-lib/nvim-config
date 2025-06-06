return {
  "rcarriga/nvim-notify",
  config = function()
    local notify = require("notify")
    vim.notify = notify

    notify.setup({
      -- Optional settings
      stages = "fade",           -- "fade", "slide", "fade_in_slide_out", "static"
      timeout = 3000,            -- how long to display messages
      background_colour = "#000000", -- background color for notifications
      render = "default",        -- or "minimal", "simple", "compact"
      max_width = 80,
      max_height = nil,
    })
  end,
}
