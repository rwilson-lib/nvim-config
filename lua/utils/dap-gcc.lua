local dap = require("dap")
-- NOTE
-- https://www.youtube.com/watch?v=lsFoZIg-oDs
dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = "/absolute/path/to/cpptools/extension/debugAdapters/bin/OpenDebugAD7",
}

-- register gdb adapter
-- dap.adapters.gdb = {
--   type = "executable",
--   command = "gdb",
--   args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
-- }

-- configurate gdb debugger
-- dap.configurations.c = {
--   {
--     name = "Launch",
--     type = "gdb",
--     request = "launch",
--     program = function()
--       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--     end,
--     cwd = "${workspaceFolder}",
--     stopAtBeginningOfMainSubprogram = false,
--   },
--   {
--     name = "Select and attach to process",
--     type = "gdb",
--     request = "attach",
--     program = function()
--       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--     end,
--     pid = function()
--       local name = vim.fn.input("Executable name (filter): ")
--       return require("dap.utils").pick_process({ filter = name })
--     end,
--     cwd = "${workspaceFolder}",
--   },
--   {
--     name = "Attach to gdbserver :1234",
--     type = "gdb",
--     request = "attach",
--     target = "localhost:1234",
--     program = function()
--       return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
--     end,
--     cwd = "${workspaceFolder}",
--   },
-- }
-- dap.configurations.cpp = dap.configurations.c
-- dap.configurations.rust = dap.configurations.c

-- configure vscode-cpp-tool debugAdapters
dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
  },
  {
    name = "Attach to gdbserver :1234",
    type = "cppdbg",
    request = "launch",
    MIMode = "gdb",
    miDebuggerServerAddress = "localhost:1234",
    miDebuggerPath = "/usr/bin/gdb",
    cwd = "${workspaceFolder}",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
  },
}
