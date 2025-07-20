return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local function win_buf_component()
      local win = vim.fn.winnr()
      local buf = vim.api.nvim_get_current_buf()
      return string.format("%d:%d", win, buf)
    end
    require("lualine").setup({
      options = {
        ignore_focus = {
          "undotree",
          "Avante",
          "dbee",
          "dapui_scopes",
          "dapui_stacks",
          "dapui_watches",
          "dapui_breakpoints",
        },
      },
      sections = {
        lualine_a = {
          { win_buf_component },
          "mode",
        },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = {
          "encoding",
          "fileformat",
          "filetype",
          {
            function()
              -- Check if MCPHub is loaded
              if not vim.g.loaded_mcphub then
                return "󰐻 -"
              end

              local count = vim.g.mcphub_servers_count or 0
              local status = vim.g.mcphub_status or "stopped"
              local executing = vim.g.mcphub_executing

              -- Show "-" when stopped
              if status == "stopped" then
                return "󰐻 -"
              end

              -- Show spinner when executing, starting, or restarting
              if executing or status == "starting" or status == "restarting" then
                local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                local frame = math.floor(vim.loop.now() / 100) % #frames + 1
                return "󰐻 " .. frames[frame]
              end

              return "󰐻 " .. count
            end,
            color = function()
              if not vim.g.loaded_mcphub then
                return { fg = "#6c7086" } -- Gray for not loaded
              end

              local status = vim.g.mcphub_status or "stopped"
              if status == "ready" or status == "restarted" then
                return { fg = "#50fa7b" } -- Green for connected
              elseif status == "starting" or status == "restarting" then
                return { fg = "#ffb86c" } -- Orange for connecting
              else
                return { fg = "#ff5555" } -- Red for error/stopped
              end
            end,
          },
        },
        lualine_y = {
          "progrmss",
          {
            "diagnosti",
            sources = { "nvim_workspace_diagnostic" },
          },
        },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { win_buf_component, "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
