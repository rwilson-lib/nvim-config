local opt = vim.opt
local g = vim.g
local cmd = vim.cmd

cmd("let g:netrw_liststyle = 3") -- change the default file explore to a tree like style

-- Enable Lua-based filetype detection
g.do_filetype_lua = 1
g.did_load_filetypes = 0
cmd("filetype plugin indent on")

opt.backspace = "indent,eol,start"

-- apperance
opt.termguicolors = true
opt.background = "dark"
-- Set colorscheme
cmd.colorscheme("catppuccin")

opt.signcolumn = "yes"
opt.number = true

-- buffers and windows
opt.splitright = true
opt.splitbelow = true

-- tabs and indent
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- search
opt.ignorecase = true
opt.smartcase = true

-- manage files
opt.swapfile = true -- Enable swapfile
vim.opt.undofile = true -- Enable persistent undo

--
local undodir = vim.fn.expand("~/.local/share/nvim/undodir")
-- Check if the undo directory already exists.
-- `vim.fn.isdirectory()` is the Lua equivalent of Vimscript's `isdirectory()`.
if not vim.fn.isdirectory(undodir) then
  -- If the directory does not exist, create it.
  -- `vim.fn.mkdir(path, "p", 0700)` creates the directory and any
  -- necessary parent directories ("p" flag) with permissions 0700
  -- (read/write/execute for owner only).
  vim.fn.mkdir(undodir, "p", 0700)
end
-- Set the 'undodir' option to our chosen directory.
-- `vim.opt.undodir` is the Lua way to access and set Vim options.
vim.opt.undodir = undodir
-- Enable the 'undofile' option.
-- This tells Neovim to actually save undo history to files in the `undodir`.
vim.opt.undofile = true

local swapdir = vim.fn.expand("~/.local/share/nvim/swap")
if not vim.fn.isdirectory(swapdir) then
  vim.fn.mkdir(swapdir, "p", 0700)
end
-- The `//` at the end is crucial for unique swap file names!
vim.opt.directory = swapdir .. "//"
vim.opt.swapfile = true -- Ensure swap files are enabled (default, but good to be explicit)

-- folds
vim.o.foldcolumn = "1"
