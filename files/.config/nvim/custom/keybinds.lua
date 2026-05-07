-- TODOs:
-- Uniform <M-x> and <A-x> (both alt keys)
-- registers copy/paste
-- highlight TODO keyword
--
-- Functions
local function clear_tags()
  vim.fn.settagstack(vim.fn.winnr(), { items = {} })
  vim.api.nvim_echo({ { 'Tag list emptied', 'Normal' } }, false, {})
end

local function toggle_wrap()
  local saved_row = vim.fn.winline()
  vim.wo.wrap = not vim.wo.wrap
  local diff = vim.fn.winline() - saved_row
  if diff ~= 0 then
    local key  = diff > 0 and '<C-e>' or '<C-y>'
    local keys = vim.api.nvim_replace_termcodes(math.abs(diff) .. key, true, false, true)
    vim.api.nvim_feedkeys(keys, 'n', false)
  end
end

local function toggle_loc()
  local loclist = vim.fn.getloclist(0, { winid = 0 })
  if loclist.winid ~= 0 then
    vim.cmd.lclose()
  else
    vim.cmd.lopen()
  end
end

local function search_selection()
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

local function jump_to_other_file(forward)
  local current_bufnr = vim.api.nvim_get_current_buf()          -- buffer we're jumping away from
  local jumps, pos = unpack(vim.fn.getjumplist())               -- jumps: 1-indexed list of {bufnr,lnum,col}; pos: 0-based index of current entry

  local start = forward and pos + 2 or pos   -- pos+1 is current entry (1-based), so +2 is next; pos is previous
  local stop  = forward and #jumps or 1      -- walk to the newest or oldest end of the list
  local step  = forward and 1 or -1          -- direction of iteration

  for i = start, stop, step do
    local entry = jumps[i]                                                    -- jump record at this position
    if entry and vim.api.nvim_buf_is_valid(entry.bufnr)                       -- skip stale/closed buffers
      and entry.bufnr ~= current_bufnr then                                   -- skip entries in the same file
      local steps = math.abs(i - (pos + 1))                                  -- pos is 0-based so pos+1 is the 1-based current; distance to target index i
      local key = steps .. (forward and '<C-i>' or '<C-o>')                  -- counted jump: e.g. "3<C-o>" goes back 3 entries in one native operation
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', false)
      return
    end
  end
  vim.notify(forward and 'Already on last file' or 'Already on first file', vim.log.levels.WARN)
end

-- Basic navigation
vim.keymap.set('n', 'h', '<Backspace>')
vim.keymap.set('n', 'l', '<Space>')
vim.keymap.set('v', 'h', '<Backspace>')
vim.keymap.set('v', 'l', '<Space>')
vim.keymap.set({ 'n', 'v', 'o' }, '0', '^')
vim.keymap.set({ 'n', 'v', 'o' }, '^', '0')
--[[
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { silent = true })
--]]

-- Code navigation
vim.keymap.set('n', '<C-n>', '<C-]>',        { silent = true })
vim.keymap.set('n', '<C-h>', _G.with_flash(function() vim.cmd.pop() end), { silent = true })
vim.keymap.set('n', '<C-t>', clear_tags) -- default: pop tag stack (jump back)

-- File navigation
vim.keymap.set('n', '<C-left>',   '<Cmd>bp<CR>',                { silent = true }) -- default: word backward (b)
vim.keymap.set('n', '<C-right>',  '<Cmd>bn<CR>',                { silent = true }) -- default: word forward (w)
vim.keymap.set('n', '<leader>o', function() jump_to_other_file(false) end)
vim.keymap.set('n', '<leader>i', function() jump_to_other_file(true) end)

-- Binds
vim.keymap.set('n', 'U', '<Cmd>redo<CR>')
vim.keymap.set('n', '<leader>w', toggle_wrap)
vim.keymap.set('',  'Y', '"+y')

-- Insert-mode
vim.keymap.set({'i', 'c'}, '<M-h>', '<C-o><Backspace>')
vim.keymap.set({'i', 'c'}, '<M-l>', '<C-o><Space>')
vim.keymap.set('i', '<M-j>', '<Down>')
vim.keymap.set('i', '<M-k>', '<Up>')
vim.keymap.set('i', '<C-M-l>', '<C-o>w')
vim.keymap.set('i', '<C-M-h>', '<C-o>b')

vim.keymap.set('i', '<C-a>', '<Esc>I')     -- default: re-insert previously inserted text
vim.keymap.set('i', '<C-e>', '<End>')      -- default: insert char below cursor

vim.keymap.set('i', '<M-p>', '<C-r>"')     -- paste unnamed register
vim.keymap.set('i', '<C-d>', '<Del>')      -- default: delete one indent level
vim.keymap.set('i', '<C-k>', '<C-o>C')     -- default: insert digraph
vim.keymap.set('i', '<C-x>', '<Cmd>w<CR>') -- default: CTRL-X completion sub-mode

-- Horizontal scroll
vim.keymap.set('n', '<leader>h', 'zH', { silent = true })
vim.keymap.set('n', '<leader>l', 'zL', { silent = true })

-- Windows / Tabs
vim.keymap.set('n', '<A-h>',      '<C-w><C-h>',                 { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>',      '<C-w><C-l>',                 { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>',      '<C-w><C-j>',                 { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>',      '<C-w><C-k>',                 { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-j>',      '<Cmd>tabn<CR>',              { silent = true }) -- default: line down (j)
vim.keymap.set('n', '<C-k>',      '<Cmd>tabp<CR>',              { silent = true })
vim.keymap.set('n', '<C-w><C-t>', '<C-w>T')                                        -- default: go to top-left window
vim.keymap.set({ 'n', 'v' }, '<C-w><C-w>', '<C-w>c',            { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-w>w',     '<C-w>c',            { silent = true })

vim.keymap.set('n', '<M-down>',   '<Cmd>resize +1<CR>',         { silent = true })
vim.keymap.set('n', '<M-up>',     '<Cmd>resize -1<CR>',         { silent = true })
vim.keymap.set('n', '<M-left>',   '<Cmd>vertical resize -1<CR>',{ silent = true })
vim.keymap.set('n', '<M-right>',  '<Cmd>vertical resize +1<CR>',{ silent = true })
-- vim.keymap.set('n', '<C-r>',      toggle_loc,                   { silent = true })

-- Search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '#', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
  vim.v.searchforward = 1
  vim.opt.hlsearch = true
end, { silent = true })

vim.keymap.set('n', '*', function()
  vim.fn.setreg('*', vim.fn.expand('<cword>'))
  vim.cmd('normal! *')
end, { silent = true })

-- TODO: $^ error, '.' regex
vim.keymap.set('v', '*', function()
  local saved, saved_type = vim.fn.getreg('"'), vim.fn.getregtype('"')
  vim.cmd('normal! "*y')
  vim.fn.setreg('"', saved, saved_type)
  search_selection()
end)

-- Selection
vim.keymap.set('n', 'vi/', 'T/vt/', { silent = true })
vim.keymap.set('n', 'va/', 'F/vf/', { silent = true })

-- Command-mode
vim.keymap.set('c', '<C-a>', '<Home>', { silent = true })

-- Unbinds
vim.keymap.set('n', '<C-w>n', '<Nop>') -- default: open new empty window
