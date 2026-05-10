-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function() vim.hl.on_yank({ higroup = 'YankHighlight' }) end,
})

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
vim.opt.shada     = "'0,/0,:1000,@0,f0" -- = 'NONE'
vim.opt.wildignore:append({ '*.o', '*.a', '*.git' })

-- Search
vim.o.hlsearch    = true
vim.o.incsearch   = true
vim.o.wrapscan    = true
vim.o.ignorecase  = true
vim.o.smartcase   = true

-- Behaviour
vim.o.startofline = true
vim.o.inccommand  = 'split'
vim.o.confirm     = true

--[[
-- Misc
--]]

-- Hover (swap is disabled)
vim.o.updatetime = 250
