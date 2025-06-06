vim.cmd("let g:netrw_liststyle = 3")         -- change the default file explore to a tree like style


local opt                       = vim.opt
local g                         = vim.g

g.mapleader                     = " "       -- Sets <leader> to space
g.maplocalleader                = ","  -- Optional: localleader, for plugin mappings

opt.backspace                   = "indent,eol,start"

-- apperance
opt.termguicolors               = true
opt.background                  = "dark"
opt.signcolumn                  = "yes"
opt.number                      = true


-- buffers and windows 
opt.splitright                  = true
opt.splitbelow                  = true

-- tabs and indent
opt.tabstop                     = 2
opt.shiftwidth                  = 2
opt.expandtab                   = true
opt.autoindent                  = true

-- search
opt.ignorecase                  = true
opt.smartcase                   = true

-- manage files
opt.swapfile                    = true  -- Enable swapfile
vim.opt.undofile                = true  -- Enable persistent undo

--
-- Function to check if a directory exists
local function is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == 'directory'
end

-- Set undo and swap directories relative to the project root
if is_directory(".vim") then
  vim.opt.undodir = "./.vim/undo//"
  vim.opt.directory = "./.vim/swap//"
else
  -- Fallback in case .vim doesn't exist in the project root
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undo//"
  vim.opt.directory = os.getenv("HOME") .. "/.vim/swap//"
end
