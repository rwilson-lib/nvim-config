---@diagnostic disable: undefined-field
return {
  -- https://www.youtube.com/watch?v=yx611gDdysc
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    "theHamsta/nvim-dap-virtual-text",
    "igorlfs/nvim-dap-view",
    { "leoluz/nvim-dap-go", lazy = true, ft = { "go" } },
    { "mfussenegger/nvim-dap-python", lazy = true, ft = { "python" } },
    "jbyuki/one-small-step-for-vimkind",
  },

  -- stylua: ignore
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "DAP: Continue/Start Debugging", },
    { "<Leader>dd", function() require("dap").run_last() end, desc = "DAP: Run Last Debug Session", },
    { "<Leader>dD", function() require("dap").continue() end, desc = "DAP: Continue/Start Debugging", },
    { "<F9>", function()
      if vim.v.count > 0 then vim.api.nvim_win_set_cursor(0, {vim.v.count, 0}) end
      require("dap").toggle_breakpoint() end , desc = "toggle breakpoint", },
    { "<leader>db", function()
      if vim.v.count > 0 then vim.api.nvim_win_set_cursor(0, {vim.v.count, 0}) end
      require("dap").toggle_breakpoint() end , desc = "toggle breakpoint", },
    { "<Leader>dBc", function()
      if vim.v.count > 0 then vim.api.nvim_win_set_cursor(0, {vim.v.count, 0}) end
      require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "DAP: Set Breakpoint with Condition", },
    { "<Leader>dBl", function()
      if vim.v.count > 0 then vim.api.nvim_win_set_cursor(0, {vim.v.count, 0}) end
      require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end, desc = "DAP: Set Logpoint", },
  },

  init = function()
    require("utils.dap-gcc")
  end,

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local dapview = require("dap-view")
    local dapwidgets = require("dap.ui.widgets")

    require("dap-go").setup()
    require("dap-python").setup("uv")
    require("nvim-dap-virtual-text").setup({})

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "Error" })
    vim.fn.sign_define("DapStopped", {
      text = "▶",
      texthl = "Visual",
      linehl = "Debug",
      numhl = "Debug",
    })
    vim.fn.sign_define("DapBreakpointRejected", {
      text = "○", -- hollow small circle
      texthl = "WarningMsg",
      linehl = "",
      numhl = "",
    })

    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }

    dap.adapters["nlua"] = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end

    vim.keymap.set("n", "<leader>dl", function()
      require("osv").launch({ port = 8086 })
    end, { noremap = true }, { silent = true, desc = "DAP: Launch OSV Debugger" })

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

    local toggle_dapui = (function()
      local state = 0 -- private state

      return function(close)
        if close then
          dapview.close()
          dapui.close()
          state = 0
          return
        end

        if state == 0 then
          dapui.close()
          dapview.open()
          state = 1
        elseif state == 1 then
          dapview.close()
          dapui.setup()
          dapui.open()
          state = 0
        end
      end
    end)()

    dap.listeners.before.attach.dapui_config = function()
      vim.api.nvim_exec_autocmds("User", { pattern = "DapStart" })
      dapview.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      vim.api.nvim_exec_autocmds("User", { pattern = "DapStart" })
      dapview.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      vim.api.nvim_exec_autocmds("User", { pattern = "DapStop" })
      toggle_dapui(true)
    end
    dap.listeners.before.event_exited.dapui_config = function()
      vim.api.nvim_exec_autocmds("User", { pattern = "DapStop" })
      toggle_dapui(true)
    end

    --local widgets = require("dap.ui.widgets")
    --widgets.centered_float(widgets.frames)
    --widgets.centered_float(widgets.scopes)

    local DAP_PREFIX = "<Leader>d"
    local dap_keymaps = {
      { "n", DAP_PREFIX .. "n", dap.step_over, { noremap = true, desc = "DAP: Step Over" } },
      { "n", DAP_PREFIX .. "i", dap.step_into, { noremap = true, desc = "DAP: Step Into" } },
      { "n", DAP_PREFIX .. "o", dap.step_out, { noremap = true, desc = "DAP: Step Out" } },
      { "n", DAP_PREFIX .. "c", dap.continue, { noremap = true, desc = "DAP: Continue" } },
      { "n", DAP_PREFIX .. "x", toggle_dapui, { noremap = true, desc = "DAP: Toggle UI" } },
      { "n", DAP_PREFIX .. "w", "<cmd>DapViewWatch<CR>", { noremap = true, desc = "DAP: Add Watch" } },
      { "n", DAP_PREFIX .. "r", dap.repl.open, { noremap = true, desc = "DAP: REPL" } },
      { "n", DAP_PREFIX .. "q", dap.terminate, { noremap = true, desc = "DAP: Terminate" } },
      { "n", DAP_PREFIX .. "K", dapwidgets.hover, { noremap = true, desc = "DAP: Hover Variable" } },
      { "n", DAP_PREFIX .. " ", dapwidgets.preview, { noremap = true, desc = "DAP: Preview Expression" } },
    }

    local dap_keymap = function(tbl, del)
      for _, map in pairs(tbl) do
        local mode = map[1]
        local key = map[2]
        local action = map[3]
        local opts = map[4]
        if del then
          pcall(vim.keymap.del, mode, key)
        else
          pcall(vim.keymap.set, mode, key, action, opts)
        end
      end
    end

    local my_dap_events = vim.api.nvim_create_augroup("MyDapEvents", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      group = my_dap_events,
      pattern = "DapStart",
      callback = function(_)
        dap_keymap(dap_keymaps)
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = my_dap_events,
      pattern = "DapStop",
      callback = function(_)
        dap_keymap(dap_keymaps, true)
      end,
    })
  end,
}
