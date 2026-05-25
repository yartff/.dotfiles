-- TODOs:
-- Uniform <M-x> and <A-x> (both alt keys)
-- registers copy/paste
-- highlight TODO keyword
--
-- Functions
local function clear_tags()
	vim.fn.settagstack(vim.fn.winnr(), { items = {} })
	vim.cmd.redrawstatus()
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

local function toggle_qf()
	local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
	if qf_winid ~= 0 then
		vim.cmd.cclose()
	else
		vim.cmd.copen()
	end
end

local function jump_to_other_file(forward)
	local current_bufnr = vim.api.nvim_get_current_buf() -- buffer we're jumping away from
	local jumps, pos    = unpack(vim.fn.getjumplist())  -- jumps: 1-indexed list of {bufnr,lnum,col}; pos: 0-based index of current entry

	local start         = forward and pos + 2 or
			pos                                      -- pos+1 is current entry (1-based), so +2 is next; pos is previous
	local stop          = forward and #jumps or 1 -- walk to the newest or oldest end of the list
	local step          = forward and 1 or -1    -- direction of iteration

	for i = start, stop, step do
		local entry = jumps[i]                            -- jump record at this position
		if entry and vim.api.nvim_buf_is_valid(entry.bufnr) -- skip stale/closed buffers
				and entry.bufnr ~= current_bufnr then         -- skip entries in the same file
			local steps = math.abs(i - (pos + 1))           -- pos is 0-based so pos+1 is the 1-based current; distance to target index i
			local key = steps ..
					(forward and '<C-i>' or '<C-o>')            -- counted jump: e.g. "3<C-o>" goes back 3 entries in one native operation
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', false)
			return
		end
	end
	vim.notify(forward and 'Already on last file' or 'Already on first file', vim.log.levels.WARN)
end

-- Search navigation with wrap flash
local function search_next(dir)
	local before = vim.fn.searchcount({ recompute = true })
	local ok = pcall(vim.cmd, 'normal! ' .. dir)
	if not ok then
		_G.flash_statusline('#cc0000')
		return
	end
	local after = vim.fn.searchcount({ recompute = true })
	local wrapped = after.total > 0 and (
		(dir == 'n' and before.current == before.total and after.current == 1) or
		(dir == 'N' and before.current == 1 and after.current == after.total)
	)
	if wrapped then _G.flash_statusline('#cc9011') end
end
vim.keymap.set('n', 'n', function() search_next('n') end, { silent = true })
vim.keymap.set('n', 'N', function() search_next('N') end, { silent = true })

-- Basic navigation
vim.keymap.set({ 'n', 'v' }, ';', ':')
vim.keymap.set({ 'n', 'v' }, ',', ';')
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
vim.keymap.set('n', '<C-n>', '<C-]>', { silent = true })
vim.keymap.set('n', '<C-h>', function()
	if vim.fn.gettagstack().curidx > 1 then
		_G.withFlash_fileChange(vim.cmd.pop)()
	else
		vim.notify('At bottom of tag stack', vim.log.levels.WARN)
	end
end, { silent = true })
vim.keymap.set('n', '<C-t>', clear_tags) -- default: pop tag stack (jump back)
vim.keymap.set('n', '<C-o>', _G.withFlash_fileChange(function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>', true, false, true), 'n', false)
end), { silent = true })
vim.keymap.set('n', '<C-i>', _G.withFlash_fileChange(function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-i>', true, false, true), 'n', false)
end), { silent = true })

-- File navigation
vim.keymap.set('n', '<C-left>', '<Cmd>bp<CR>', { silent = true })  -- default: word backward (b)
vim.keymap.set('n', '<C-right>', '<Cmd>bn<CR>', { silent = true }) -- default: word forward (w)
vim.keymap.set('n', '<leader>o', function() jump_to_other_file(false) end)
vim.keymap.set('n', '<leader>i', function() jump_to_other_file(true) end)

-- Binds
vim.keymap.set('n', 'U', '<Cmd>redo<CR>')
vim.keymap.set('n', '<leader>w', toggle_wrap)
vim.keymap.set('', 'Y', '"+y')
vim.keymap.set('x', 'p', '"dd"0P', { silent = true })

-- Insert-mode
vim.keymap.set({ 'i', 'c' }, '<M-h>', '<C-o><Backspace>')
vim.keymap.set({ 'i', 'c' }, '<M-l>', '<C-o><Space>')
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
vim.keymap.set('n', '<A-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-j>', '<Cmd>tabn<CR>', { silent = true })
vim.keymap.set('n', '<C-k>', '<Cmd>tabp<CR>', { silent = true })
vim.keymap.set('n', '<C-w><C-t>', '<Cmd>tab split<CR>')
vim.keymap.set('n', '<C-w><C-q>', '<Cmd>tabclose<CR>')
vim.keymap.set({ 'n', 'v' }, '<C-w><C-w>', '<C-w>c', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-w>w', '<C-w>c', { silent = true })
vim.keymap.set('n', '<C-w>W', '<Cmd>bw<CR>', { silent = true })

vim.keymap.set('n', '<M-down>', '<Cmd>resize +1<CR>', { silent = true })
vim.keymap.set('n', '<M-up>', '<Cmd>resize -1<CR>', { silent = true })
vim.keymap.set('n', '<M-left>', '<Cmd>vertical resize -1<CR>', { silent = true })
vim.keymap.set('n', '<M-right>', '<Cmd>vertical resize +1<CR>', { silent = true })
-- vim.keymap.set('n', '<C-r>',      toggle_loc,                   { silent = true })
vim.keymap.set('n', '<C-q>', toggle_qf, { silent = true })

-- Search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '*', function()
	vim.fn.setreg('*', vim.fn.expand('<cword>'))
	vim.cmd('normal! *')
end, { silent = true })

vim.keymap.set('n', '#', function()
	local word = vim.fn.expand('<cword>')
	vim.fn.setreg('*', word)
	vim.fn.setreg('/', '\\<' .. word .. '\\>')
	vim.v.searchforward = 1
	vim.opt.hlsearch = true
end, { silent = true })

-- Selection
vim.keymap.set('n', 'vi/', 'T/vt/', { silent = true })
vim.keymap.set('n', 'va/', 'F/vf/', { silent = true })

-- Registers
vim.keymap.set('n', '<leader>"', '<Cmd>registers<CR>', { silent = true })

-- Command-mode
vim.keymap.set('c', '<C-a>', '<Home>', { silent = true })

-- Unbinds
vim.keymap.set('n', '<C-LeftMouse>', '<Nop>') -- default: jump to tag
vim.keymap.set('n', '<C-w>n', '<Nop>')        -- default: open new empty window
