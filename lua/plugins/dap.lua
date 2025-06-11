return {
  "mfussenegger/nvim-dap",

  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "leoluz/nvim-dap-go",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("dap-go").setup()
    require("dapui").setup()
    require("nvim-dap-virtual-text").setup()

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

    vim.keymap.set({ 'n', 'i' }, '<F5>', "<cmd>DapContinue<cr>", { desc = 'DAP: Continue' })
    vim.keymap.set({ 'n', 'i' }, '<F10>', "<cmd>DapStepOver<cr>", { desc = 'DAP: Step Over' })
    vim.keymap.set({ 'n', 'i' }, '<F11>', "<cmd>DapStepInto<cr>", { desc = 'DAP: Step Into' })
    vim.keymap.set({ 'n', 'i' }, '<F12>', "<cmd>DapStepOut<cr>", { desc = 'DAP: Step Out' })
    vim.keymap.set({ 'n', 'i' }, '<F8>', "<cmd>DapToggleBreakpoint<cr>", { desc = 'DAP: Toggle Breakpoint' })
    vim.keymap.set({ 'n', 'i' }, '<F9>', function()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end, { desc = 'DAP: Set Log Point' })

    vim.keymap.set('n', '<Leader>dr', function() dap.repl.open() end, { desc = 'DAP: Open REPL' })
    vim.keymap.set('n', '<Leader>dl', function() dap.run_last() end, { desc = 'DAP: Run Last' })

    vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
      require('dap.ui.widgets').hover()
    end, { desc = 'DAP: Hover' })

    vim.keymap.set({ 'n', 'v' }, '<Leader>dp', function()
      require('dap.ui.widgets').preview()
    end, { desc = 'DAP: Preview' })

    vim.keymap.set('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end, { desc = 'DAP: Show Frames' })

    vim.keymap.set('n', '<Leader>ds', function()
      require('dap.ui.widgets').toggle_scopes()
    end, { desc = 'DAP: Toggle Scopes' })
  end
}
