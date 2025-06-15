---@diagnostic disable: undefined-field
return {
  -- https://www.youtube.com/watch?v=yx611gDdysc
  "mfussenegger/nvim-dap",
  -- vim.keymap.set({ "n", "i" }, "<F8>", "<cmd>DapToggleBreakpoint<cr>", { desc = "DAP: Toggle Breakpoint" })

  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "DAP: Continue/Start Debugging",
    },
    {
      "<F9>",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<Leader>dbb",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle Breakpoint",
    },
    {
      "<Leader>dbB",
      function()
        require("dap").set_breakpoint()
      end,
      desc = "DAP: Set Breakpoint with Condition",
    },
    {
      "<Leader>dbl",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end,
      desc = "DAP: Set Logpoint",
    },
    {
      "<Leader>drl",
      function()
        require("dap").run_last()
      end,
      desc = "DAP: Run Last Debug Session",
    },
  },
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    "theHamsta/nvim-dap-virtual-text",
    { "leoluz/nvim-dap-go", lazy = true, ft = { "go" } },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    require("dap-go").setup()

    ---@diagnostic disable-next-line: missing-parameter
    require("nvim-dap-virtual-text").setup()
    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set("", "<F10>", function()
      dap.step_over()
    end, { desc = "DAP: Step Over" })

    vim.keymap.set("", "<F11>", function()
      dap.step_into()
    end, { desc = "DAP: Step Into" })

    vim.keymap.set("", "<F12>", function()
      dap.step_out()
    end, { desc = "DAP: Step Out" })

    vim.keymap.set("n", "<Leader>dir", function()
      dap.repl.open()
    end, { desc = "DAP: Open REPL" })

    vim.keymap.set({ "n", "v" }, "<eader>duh", function()
      require("dap.ui.widgets").hover()
    end, { desc = "DAP: Hover Variables" })

    vim.keymap.set({ "n", "v" }, "<Leader>dup", function()
      require("dap.ui.widgets").preview()
    end, { desc = "DAP: Preview Expression" })

    vim.keymap.set("n", "<Leader>duf", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end, { desc = "DAP: Show Call Stack (Frames)" })

    vim.keymap.set("n", "<Leader>dis", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end, { desc = "DAP: Show Variable Scopes" })
  end,
}
