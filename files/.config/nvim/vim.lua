-- Filetype and syntax
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Runtime path
vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim/bundle/ctrlp.vim'))

-- ── GENERAL ──────────────────────────────────────────────────────────────────
vim.opt.shiftwidth = 2

-- Search
vim.opt.hlsearch   = true
vim.opt.incsearch  = true
vim.opt.wrapscan   = true
vim.opt.ignorecase = true
vim.opt.smartcase  = true

-- GUI
vim.opt.scrolloff  = 4
vim.opt.wrap       = false
vim.opt.laststatus = 2
vim.opt.showcmd    = true
vim.opt.showmode   = true
vim.opt.number     = true
vim.opt.showmatch  = true
vim.opt.matchtime  = 3

-- Folding
vim.opt.foldopen:remove('block')

-- System
vim.opt.shell       = 'bash'
vim.opt.mouse       = 'a'
vim.opt.autoread    = true
vim.opt.backup      = false
vim.opt.writebackup = false
vim.opt.swapfile    = false
vim.opt.wildmenu    = true
vim.opt.wildmode    = 'full'
vim.opt.wildignore:append({ '*.o', '*.a', '*.git' })
vim.opt.cpoptions   = 'ces$'

-- Colorcolumn: highlight columns 90-101
local cols = {}
for i = 90, 101 do cols[#cols + 1] = tostring(i) end
vim.opt.colorcolumn = table.concat(cols, ',')

-- Colorscheme
pcall(vim.cmd, 'colorscheme railscasts')

-- ── FUNCTIONS ─────────────────────────────────────────────────────────────────
local function ClearTags()
  vim.fn.settagstack(vim.fn.winnr(), { items = {} })
  vim.api.nvim_echo({ { 'Tag list emptied', 'Normal' } }, false, {})
end

local function TogglePaste()
  if vim.o.paste then
    vim.cmd('set nopaste')
  else
    vim.cmd('set paste')
  end
end

local function ToggleCopy()
  local currpos = vim.fn.winnr()
  local currtab = vim.fn.tabpagenr()
  if vim.o.number then
    vim.cmd("tabdo execute 'windo execute \"set nonumber\"'")
    vim.o.mouse = ''
  else
    vim.cmd("tabdo execute 'windo execute \"set number\"'")
    vim.o.mouse = 'a'
  end
  vim.cmd('tabn ' .. currtab)
  vim.cmd(currpos .. 'wincmd w')
  TogglePaste()
end

local function ToggleWrap()
  vim.opt.wrap = not vim.o.wrap
end

local function ToggleLoc()
  local loclist = vim.fn.getloclist(0, { winid = 0 })
  if loclist.winid ~= 0 then
    vim.cmd('lcl')
  else
    vim.cmd('lopen')
  end
end

local function SearchSelection()
  local press_n = false
  local text     = vim.fn.getreg('*')
  local text_ori = vim.fn.escape(text, '\\/.$^~[]')
  text = vim.fn.substitute(text_ori, '^\\s\\+', '', '')
  if text ~= text_ori then press_n = true end
  text = vim.fn.substitute(text, '\\n', '\\\\n', 'g')
  vim.fn.setreg('/', '\\V' .. text)
  vim.cmd('normal! n')
  if press_n then vim.cmd('normal! n') end
  vim.cmd('redraw')
end

-- ── KEYMAPS ───────────────────────────────────────────────────────────────────
-- Basic navigation
--[[
vim.keymap.set('n', 'h', '<Backspace>')
vim.keymap.set('n', 'l', '<Space>')
vim.keymap.set('v', 'h', '<Backspace>')
vim.keymap.set('v', 'l', '<Space>')
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { silent = true })
--]]

-- Binds
vim.keymap.set('n', 'U', ':redo<CR>')
vim.keymap.set('n', 'Q', ToggleCopy)
vim.keymap.set('n', 'Z', ToggleWrap)
vim.keymap.set('',  'Y', '"+y')

-- Insert-mode edit
vim.keymap.set('i', '<C-k>', '<C-o>C')
vim.keymap.set('i', '<C-x>', '<C-o>:w<CR>')
vim.keymap.set('i', '<C-d>', '<Del>')
vim.keymap.set('i', '<C-a>', '<Esc>I')
vim.keymap.set('i', '<C-e>', '<End>')

-- Folding
vim.keymap.set('', 'z[', '<ESC>$zf%')
vim.keymap.set('', 'z]', '<ESC>?{<CR>zf%:noh<CR>')
vim.keymap.set('v', 'zo', ':fo<CR>')

-- Windows / Tabs
vim.keymap.set('n', '<C-left>',   ':bp<CR>',                { silent = true })
vim.keymap.set('n', '<C-right>',  ':bn<CR>',                { silent = true })
vim.keymap.set('n', '<C-j>',      ':tabn<CR>',              { silent = true })
vim.keymap.set('n', '<C-k>',      ':tabp<CR>',              { silent = true })
vim.keymap.set('n', '<C-w><C-w>', ':lcl<CR><C-w>c',         { silent = true })
vim.keymap.set('n', '<C-w><C-t>', '<C-w>T')
vim.keymap.set('n', '<C-w>j',     '<C-w>J') -- TODO ?
vim.keymap.set('n', '<C-w>h',     '<C-w>H') -- TODO ?
vim.keymap.set('n', '<M-down>',   ':resize +1<CR>',         { silent = true })
vim.keymap.set('n', '<M-up>',     ':resize -1<CR>',         { silent = true })
vim.keymap.set('n', '<M-left>',   ':vertical resize -1<CR>',{ silent = true })
vim.keymap.set('n', '<M-right>',  ':vertical resize +1<CR>',{ silent = true })
vim.keymap.set('n', '<C-r>',      ToggleLoc,                { silent = true })

-- Code navigation
vim.keymap.set('n', '<C-n>', '<C-]>',   { silent = true })
vim.keymap.set('n', '<C-h>', ':pop<CR>',{ silent = true })
vim.keymap.set('n', '<C-t>', ClearTags)
vim.keymap.set('v', '*', function()
  vim.cmd('normal! "*y')
  SearchSelection()
end)
vim.keymap.set('n', 'vi/', 'T/vt/', { silent = true })
vim.keymap.set('n', 'va/', 'F/vf/', { silent = true })

-- Unbinds
vim.keymap.set('n', '<C-w>n', '<Nop>')

-- ── AUTOCMDS ──────────────────────────────────────────────────────────────────
local augroup = vim.api.nvim_create_augroup('vimrc', { clear = true })

vim.api.nvim_create_autocmd('VimEnter', {
  group    = augroup,
  callback = function() vim.cmd('clearjumps') end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group    = augroup,
  pattern  = '*.tpp',
  callback = function() vim.bo.filetype = 'cpp' end,
})
