-- Functions
local function ClearTags()
  vim.fn.settagstack(vim.fn.winnr(), { items = {} })
  vim.api.nvim_echo({ { 'Tag list emptied', 'Normal' } }, false, {})
end

local function ToggleWrap()
  local saved_row = vim.fn.winline()
  vim.wo.wrap = not vim.wo.wrap
  local diff = vim.fn.winline() - saved_row
  if diff ~= 0 then
    local key  = diff > 0 and '<C-e>' or '<C-y>'
    local keys = vim.api.nvim_replace_termcodes(math.abs(diff) .. key, true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
  end
end

local function ToggleLoc()
  local loclist = vim.fn.getloclist(0, { winid = 0 })
  if loclist.winid ~= 0 then
    vim.cmd.lclose()
  else
    vim.cmd.lopen()
  end
end

local function SearchSelection()
  local text     = vim.fn.getreg('*')
  local text_ori = vim.fn.escape(text, '\\/.$^~[]')
  local trimmed  = text_ori:gsub('^%s+', '')
  local press_n  = trimmed ~= text_ori
  local pattern  = trimmed:gsub('\n', '\\n')
  vim.fn.setreg('/', '\\V' .. pattern)
  vim.cmd('normal! n')
  if press_n then vim.cmd('normal! n') end
  vim.cmd.redraw()
end

-- Basic navigation
vim.keymap.set('n', 'h', '<Backspace>')
vim.keymap.set('n', 'l', '<Space>')
vim.keymap.set('v', 'h', '<Backspace>')
vim.keymap.set('v', 'l', '<Space>')
--[[
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { silent = true })
--]]

vim.keymap.set({'i', 'c'}, '<M-h>', '<Left>')
vim.keymap.set({'i', 'c'}, '<M-l>', '<Right>')
vim.keymap.set('i', '<M-j>', '<Down>')
vim.keymap.set('i', '<M-k>', '<Up>')

-- Code navigation
vim.keymap.set('n', '<C-n>', '<C-]>',        { silent = true })
vim.keymap.set('n', '<C-h>', '<Cmd>pop<CR>', { silent = true })
vim.keymap.set('n', '<C-t>', ClearTags) -- default: pop tag stack (jump back)

vim.keymap.set('n', '<C-left>',   '<Cmd>bp<CR>',                { silent = true }) -- default: word backward (b)
vim.keymap.set('n', '<C-right>',  '<Cmd>bn<CR>',                { silent = true }) -- default: word forward (w)

-- Binds
vim.keymap.set('n', 'U', '<Cmd>redo<CR>')
vim.keymap.set('n', '<leader>w', ToggleWrap)
vim.keymap.set('',  'Y', '"+y')

-- Insert-mode
vim.keymap.set('i', '<C-k>', '<C-o>C')      -- default: insert digraph
vim.keymap.set('i', '<C-d>', '<Del>')        -- default: delete one indent level
vim.keymap.set('i', '<C-a>', '<Esc>I')      -- default: re-insert previously inserted text
vim.keymap.set('i', '<C-e>', '<End>')        -- default: insert char below cursor
vim.keymap.set('i', '<C-x>', '<Cmd>w<CR>') -- default: CTRL-X completion sub-mode

-- Horizontal scroll
vim.keymap.set('n', '<leader>h', 'zH', { silent = true })
vim.keymap.set('n', '<leader>l', 'zL', { silent = true })

-- Windows / Tabs
vim.keymap.set('n', '<A-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-j>',      '<Cmd>tabn<CR>',              { silent = true }) -- default: line down (j)
vim.keymap.set('n', '<C-k>',      '<Cmd>tabp<CR>',              { silent = true })
vim.keymap.set('n', '<C-w><C-w>', '<Cmd>lclose<CR><C-w>c',      { silent = true }) -- default: move to next window
vim.keymap.set('n', '<C-w><C-t>', '<C-w>T')                                         -- default: go to top-left window

vim.keymap.set('n', '<M-down>',   '<Cmd>resize +1<CR>',         { silent = true })
vim.keymap.set('n', '<M-up>',     '<Cmd>resize -1<CR>',         { silent = true })
vim.keymap.set('n', '<M-left>',   '<Cmd>vertical resize -1<CR>',{ silent = true })
vim.keymap.set('n', '<M-right>',  '<Cmd>vertical resize +1<CR>',{ silent = true })
vim.keymap.set('n', '<C-r>',      ToggleLoc,                    { silent = true }) -- default: redo

-- Search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '#', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
  vim.v.searchforward = 1
end, { silent = true })
-- TODO: $^ error, '.' regex
vim.keymap.set('v', '*', function()
  vim.cmd('normal! "*y')
  SearchSelection()
end)

-- Selection
vim.keymap.set('n', 'vi/', 'T/vt/', { silent = true })
vim.keymap.set('n', 'va/', 'F/vf/', { silent = true })

-- Command-mode
vim.keymap.set('c', '<C-a>', '<Home>', { silent = true })

-- Unbinds
vim.keymap.set('n', '<C-w>n', '<Nop>') -- default: open new empty window
