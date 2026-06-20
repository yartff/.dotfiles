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

	local start         = forward and pos + 2 or pos    -- pos+1: current, +2: next; pos: prev
	local stop          = forward and #jumps or 1       -- walk to the newest or oldest end of the list
	local step          = forward and 1 or -1           -- direction of iteration

	for i = start, stop, step do
		local entry = jumps[i]                            -- jump record at this position
		if entry and vim.api.nvim_buf_is_valid(entry.bufnr) -- skip stale/closed buffers
				and entry.bufnr ~= current_bufnr then         -- skip entries in the same file
			local steps = math.abs(i - (pos + 1))           -- pos is 0-based so pos+1 is the 1-based current; distance to target index i
			local key = steps .. (forward and '<C-i>' or '<C-o>')
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', false)
			_G.flash_statusline('#ff8800')
			return
		end
	end
	vim.notify(forward and 'Already on last file' or 'Already on first file', vim.log.levels.WARN)
end

-- Search navigation with wrap flash
local function search_next(dir)
	local before = { vim.fn.line('.'), vim.fn.col('.') }
	local ok = pcall(vim.cmd, 'normal! ' .. dir)
	if not ok then
		_G.flash_statusline('#cc0000')
		return
	end
	local after = { vim.fn.line('.'), vim.fn.col('.') }
	local wrapped = (dir == 'n' and (before[1] > after[1] or (before[1] == after[1] and before[2] >= after[2]))) or
			(dir == 'N' and (before[1] < after[1] or (before[1] == after[1] and before[2] <= after[2])))
	if wrapped then _G.flash_statusline('#cc9011') end
end
vim.keymap.set('n', 'n', function() search_next('n') end, { silent = true })
vim.keymap.set('n', 'N', function() search_next('N') end, { silent = true })

-- [[ Basic navigation ]]
vim.keymap.set({ 'n', 'v' }, ';', ':')
vim.keymap.set({ 'n', 'v' }, ',', ';')
vim.keymap.set({ 'n', 'v' }, 'h', '<Backspace>')
vim.keymap.set({ 'n', 'v' }, 'l', '<Space>')
vim.keymap.set({ 'n', 'v', 'o' }, '0', '^')
vim.keymap.set({ 'n', 'v', 'o' }, '^', '0')
-- TODO: <leader>e <leader>y up/down without moving cursor
--[[
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { silent = true })
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { silent = true })
--]]

-- [[ Code navigation ]]
vim.keymap.set('n', '<C-n>', '<C-]>', { silent = true })
vim.keymap.set('n', '<C-h>', function()
	if vim.fn.gettagstack().curidx > 1 then
		_G.withFlash_fileChange(vim.cmd.pop)()
		vim.cmd.redrawstatus() -- redraws even if pos did not change. Ignorable overhead
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

vim.keymap.set('n', '<leader><C-h>', '<Cmd>tag<CR>', { silent = true })

-- [[ File navigation ]]
vim.keymap.set('n', '<C-left>', '<Cmd>bp<CR>', { silent = true })  -- default: word backward (b)
vim.keymap.set('n', '<C-right>', '<Cmd>bn<CR>', { silent = true }) -- default: word forward (w)
vim.keymap.set('n', '<leader>o', function() jump_to_other_file(false) end)
vim.keymap.set('n', '<leader>i', function() jump_to_other_file(true) end)
vim.keymap.set('n', '<leader>x', function()
	vim.cmd('topleft vsplit | Ex') -- TODO: This locks whole vim
end, { silent = true })

-- [[ Binds ]]
vim.keymap.set('n', 'U', '<Cmd>redo<CR>')
vim.keymap.set('n', '<leader>w', toggle_wrap)
vim.keymap.set('', 'Y', '"+y')
vim.keymap.set('x', 'p', '"dd"0P', { silent = true })

-- [[ Insert-mode ]]
vim.keymap.set({ 'i', 'c' }, '<M-h>', '<C-o><Backspace>')
vim.keymap.set({ 'i', 'c' }, '<M-l>', '<C-o><Space>')
vim.keymap.set('i', '<M-j>', '<Down>')
vim.keymap.set('i', '<M-k>', '<Up>')
vim.keymap.set('i', '<C-M-l>', '<C-o>w')
vim.keymap.set('i', '<C-M-h>', '<C-o>b')

vim.keymap.set('i', '<C-a>', '<Esc>I')     -- default: re-insert previously inserted text
vim.keymap.set('i', '<C-e>', '<End>')      -- default: insert char below cursor

vim.keymap.set('i', '<C-d>', '<Del>')      -- default: delete one indent level
vim.keymap.set('i', '<C-k>', '<C-o>C')     -- default: insert digraph
vim.keymap.set('i', '<C-x>', '<Cmd>w<CR>') -- default: CTRL-X completion sub-mode

-- [[ Scroll ]]
vim.keymap.set('n', '<leader>h', 'zH', { silent = true })
vim.keymap.set('n', '<leader>l', 'zL', { silent = true })

-- [[ Windows / Tabs ]]
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
vim.keymap.set('n', '<C-q>', toggle_qf, { silent = true })

-- [[ Search ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Shows '?' at the cmdline (so it reads as backward) but actually searches
-- forward -- and the view must never scroll:
-- 2. v:event.abort = true is a no-op from Lua (vim.v.event is a *copy*, the
--    write never reaches the real dict), and even via vimscript Nvim may
--    still jump for "/"/"?" cmdline types -- so winrestview undoes the final
--    jump after <CR> regardless of whether the abort attempt took effect.
vim.keymap.set('n', '?', function()
	local view         = vim.fn.winsaveview()
	local had_hlsearch = vim.o.hlsearch
	local prev_pattern = vim.fn.getreg('/')
	vim.o.incsearch    = false

	local group        = vim.api.nvim_create_augroup('NoScrollSearch', { clear = true }) -- fresh augroup, clearing any leftovers

	-- highlight all matches for whatever's typed so far, without moving the cursor
	vim.api.nvim_create_autocmd('CmdlineChanged', {
		group = group,
		pattern = '\\?',                   -- only for backward-search cmdline (escaped: literal '?')
		callback = function()
			local pattern = vim.fn.getcmdline() -- read whatever has been typed so far
			if pattern ~= '' then            -- skip an empty pattern (nothing to highlight)
				vim.fn.setreg('/', pattern)    -- push it into the search register live
				vim.opt.hlsearch = true        -- make sure matches are actually highlighted
				vim.cmd.redraw()               -- force a redraw so highlights show immediately
			end
		end,
	})

	vim.api.nvim_create_autocmd('CmdlineLeave', { -- fires once when leaving the command-line
		group = group,                             -- same group as the autocmd above
		pattern = '\\?',                           -- escaped: a bare '?' is a glob wildcard matching ANY cmdline type
		once = true,                               -- auto-remove itself after firing once
		callback = function()
			vim.o.incsearch = true
			vim.api.nvim_del_augroup_by_id(group)              -- tear down the CmdlineChanged autocmd too
			if vim.v.event.abort then                          -- cancelled (<Esc>/<C-c>): undo the live-preview register change
				vim.fn.setreg('/', prev_pattern)                 -- put the old search pattern back
				vim.opt.hlsearch = had_hlsearch                  -- put hlsearch back to its old state
				return                                           -- nothing else to do, search was cancelled
			end
			local pattern = vim.fn.getcmdline()                -- the final pattern that was confirmed with <CR>
			vim.cmd('let v:event.abort = v:true')              -- best effort, see note above
			if pattern ~= '' then                              -- skip an empty pattern (repeat-last-search case)
				vim.fn.setreg('/', pattern)                      -- store the confirmed pattern in the search register
				vim.fn.histadd('search', pattern)                -- add it to search history, like a real search would
			end
			vim.v.searchforward = 1                            -- the real command was '?' (backward) -- force forward anyway
			vim.opt.hlsearch = true                            -- keep matches highlighted after confirming
			vim.schedule(function() vim.fn.winrestview(view) end) -- next tick: snap the view back if it moved anyway
		end,
	})
	vim.api.nvim_feedkeys('?', 'n', false) -- shows '?' at the cmdline, but searchforward above keeps it forward
end, { silent = true })

local function search_cword()
	local word = vim.fn.expand('<cword>')
	vim.fn.setreg('*', word)
	vim.fn.setreg('/', '\\<' .. word .. '\\>')
	vim.v.searchforward = 1
	vim.opt.hlsearch = true
end

vim.keymap.set('n', '*', function()
	search_cword()
	search_next('n')
end, { silent = true })

vim.keymap.set('n', '#', function()
	search_cword()
end, { silent = true })

local function selection_in_search()
	local saved = vim.fn.getreg('"')
	vim.cmd.normal({ '"*y', bang = true })
	vim.fn.setreg('"', saved)
	local escaped = vim.fn.escape(vim.fn.getreg('*'), '/\\'):gsub('[ \t]+', '\\s\\*'):gsub('\n', '\\n')
	vim.fn.setreg('/', '\\V' .. escaped)
	vim.v.searchforward = 1
	vim.opt.hlsearch = true
end

vim.keymap.set('x', '*', function()
	selection_in_search()
	search_next('n')
end, { silent = true })

vim.keymap.set('x', '#', function()
	selection_in_search()
end, { silent = true })

-- Selection
vim.keymap.set('n', 'vi/', 'T/vt/', { silent = true })
vim.keymap.set('n', 'va/', 'F/vf/', { silent = true })

-- Registers
vim.keymap.set('i', '<M-p>', '<C-r>"') -- paste unnamed register
vim.keymap.set('n', '<leader>"', '<Cmd>registers<CR>', { silent = true })

-- Command-mode
vim.keymap.set('c', '<C-a>', '<Home>', { silent = true })

-- Unbinds
vim.keymap.set('n', '<C-LeftMouse>', '<Nop>') -- default: jump to tag
vim.keymap.set('n', '<C-w>n', '<Nop>')        -- default: open new empty window
vim.keymap.set('n', '<C-r>', '<Nop>')         -- default: Redo
