-- vim.api.nvim_set_hl(0, 'FlashLine', {
-- 	reverse = true,
-- 	ctermfg = 136,
-- 	fg      = '#b58900',
-- })

-- vim.fn.sign_define('wholeline', { linehl = 'Visual' })

-- local function HighlightLine(duration)
-- 	local line     = vim.api.nvim_win_get_cursor(0)[1]
-- 	local winid    = vim.api.nvim_get_current_win()
-- 	local match_id = vim.fn.matchaddpos('FlashLine', { { line } }, 100)
-- 	vim.defer_fn(function()
-- 		vim.api.nvim_win_call(winid, function() vim.fn.matchdelete(match_id) end)
-- 	end, duration)
-- end

vim.opt_local.winhighlight = 'CursorLine:QFCursorLine'

local buf = { buffer = true }

local function flash()
	local line     = vim.api.nvim_win_get_cursor(0)[1]
	local winid    = vim.api.nvim_get_current_win()
	local match_id = vim.fn.matchaddpos('Search', { { line } }, 100)
	vim.defer_fn(function()
		vim.api.nvim_win_call(winid, function() vim.fn.matchdelete(match_id) end)
	end, 150)
end

local function preview()
	local qf_win = vim.api.nvim_get_current_win()
	vim.cmd('normal! \r')
	flash()
	vim.api.nvim_set_current_win(qf_win)
end

vim.keymap.set('n', '<C-m>', function()
	vim.cmd('normal! \r')
	vim.cmd('cclose')
end, buf)

vim.keymap.set('n', 'h', preview, buf)
vim.keymap.set('n', 'J', function()
	vim.cmd('normal! j')
	preview()
end, buf)
vim.keymap.set('n', 'K', function()
	vim.cmd('normal! k')
	preview()
end, buf)
vim.keymap.set('n', '<leader>h', function()
	local idx   = vim.fn.getqflist({ idx = 0 }).idx
	local entry = vim.fn.getqflist()[idx]
	if not entry then return end
	if not vim.api.nvim_buf_is_loaded(entry.bufnr) then vim.fn.bufload(entry.bufnr) end
	require('goto-preview.lib').open_floating_win(entry.bufnr, { entry.lnum, (entry.col or 1) - 1 })
end, buf)

-- vim.keymap.set('n', '<C-w><CR>', '<C-w><CR><C-w>w<Cmd>lclose<CR><Cmd>lwindow<CR><CR>', buf)
-- vim.keymap.set('n', '<C-w><C-w>', '<C-w>c', buf)
