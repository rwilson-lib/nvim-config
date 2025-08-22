---@diagnostic disable: undefined-field
return {
  -- https://www.youtube.com/watch?v=yx611gDdysc
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    "theHamsta/nvim-dap-virtual-text",
    { "leoluz/nvim-dap-go", lazy = true, ft = { "go" } },
    { "mfussenegger/nvim-dap-python", lazy = true, ft = { "python" } },
  },

  -- stylua: ignore
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "DAP: Continue/Start Debugging", },
    { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    { "<Leader>dbb", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    { "<Leader>dbB", function() require("dap").set_breakpoint() end, desc = "DAP: Set Breakpoint with Condition", },
    { "<Leader>dbl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "DAP: Set Logpoint", },
    { "<Leader>drl", function() require("dap").run_last() end, desc = "DAP: Run Last Debug Session", },
  },

  init = function()
    require("utils.dap-gcc")
  end,

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    require("dap-go").setup()
    require("dap-python").setup("uv")
    ---@diagnostic disable-next-line: missing-parameter
    require("nvim-dap-virtual-text").setup()

    -- https://tamerlan.dev/a-guide-to-debugging-applications-in-neovim/
    -- Adapter: let nvim-dap start the js-debug adapter itself
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.adapters["pwa-chrome"] = {
      type = "server",
      host = "localhost",
      port = "5173",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "5173",
        },
      },
    }

    -- Configurations for JS/TS/React
    for _, language in ipairs({ "typescript", "typescriptreact", "javascript", "javascriptreact" }) do
      dap.configurations[language] = {
        {
          type = "pwa-chrome",
          request = "launch",
          name = "Launch Chrome against localhost",
          url = "http://localhost:5173",
        },
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach to Vite (debug port 9229)",
          port = 9229,
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          protocol = "inspector",
        },
      }
    end
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
