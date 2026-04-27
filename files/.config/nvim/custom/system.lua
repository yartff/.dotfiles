-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.timeoutlen = 400

-- System
vim.o.shell       = 'bash'
vim.o.mouse       = 'a'
vim.o.autoread    = true
vim.o.backup      = false
vim.o.writebackup = false
vim.o.swapfile    = false
vim.o.undofile    = true
vim.o.wildmenu    = true
vim.o.wildmode    = 'full'
vim.o.cpoptions   = 'ces$'
vim.opt.wildignore:append({ '*.o', '*.a', '*.git' })

-- Search
vim.o.hlsearch   = true
vim.o.incsearch  = true
vim.o.wrapscan   = true
vim.o.ignorecase = true
vim.o.smartcase  = true

-- Behaviour
vim.o.inccommand = 'split'
vim.o.confirm    = true

--[[
-- Misc
--]]

-- Hover (swap is disabled)
vim.o.updatetime = 250
