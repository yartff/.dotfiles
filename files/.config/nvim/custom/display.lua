vim.o.shiftwidth = 2

vim.o.breakindent = true
vim.o.scrolloff  = 6
vim.o.wrap       = false
vim.o.laststatus = 2
vim.o.showcmd    = true
vim.o.showmode   = true
vim.o.number     = true
vim.o.showmatch  = true
vim.o.matchtime  = 3

vim.o.splitright = true
vim.o.splitbelow = true

-- vim.o.signcolumn = 'yes'

-- Colorcolumn: highlight columns 90-101
local cols = {}
for i = 90, 101 do cols[#cols + 1] = tostring(i) end
vim.opt.colorcolumn = table.concat(cols, ',')

-- Colorscheme
pcall(vim.cmd.colorscheme, 'railscasts')

-- Misc
vim.g.have_nerd_font = false
