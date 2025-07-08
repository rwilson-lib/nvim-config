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
          "neo-tree",
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
        lualine_x = { "encoding", "fileformat", "filetype", { require("mcphub.extensions.lualine") } },
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
