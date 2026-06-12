local CTRL_E = '\x05'
local CTRL_Y = '\x19'
local CTRL_D = '\x04'
local CTRL_U = '\x15'

local function open_registers_preview(get_sequence, mode)
	local reg_names = { '"', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
		'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
		'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
		'-', '.', ':', '%', '#', '*', '+', '/' }

	-- TODO: Strip entries >= 20 lines
	local MAX_COL = 120
	local lines = {}
	for _, name in ipairs(reg_names) do
		local content = vim.fn.getreg(name)
		if content ~= '' then
			local parts = vim.split(content, '\n', { plain = true })
			if parts[#parts] == '' then table.remove(parts) end
			for i, part in ipairs(parts) do
				part = part:gsub('\t', '→')
				if #part > MAX_COL then part = part:sub(1, MAX_COL - 1) .. '…' end
				if i == 1 then
					table.insert(lines, string.format(' %s  %s', name, part))
				else
					table.insert(lines, '    ' .. part)
				end
			end
		end
	end
	if #lines == 0 then lines = { '  (empty)' } end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = 'wipe'

	local ui = vim.api.nvim_list_uis()[1]
	local max_len = 0
	for _, line in ipairs(lines) do
		local w = vim.fn.strdisplaywidth(line)
		if w > max_len then max_len = w end
	end
	local width = math.min(max_len + 2, math.floor(ui.width * 0.95))
	local height = math.min(#lines, math.floor(ui.height * 0.7))
	local win = vim.api.nvim_open_win(buf, false, {
		relative = 'editor',
		width = width,
		height = height,
		col = math.floor((ui.width - width) / 2),
		row = math.floor((ui.height - height) / 2),
		style = 'minimal',
		border = 'rounded',
		title = ' registers ',
		title_pos = 'center',
	})
	vim.wo[win].winhl = 'Normal:NormalFloat'
	vim.api.nvim_win_call(win, function() vim.fn.matchadd('String', '→') end)

	vim.cmd('redraw')
	while true do
		local ok, char = pcall(vim.fn.getcharstr)
		if not ok or char == '\27' or char == '' then
			vim.api.nvim_win_close(win, true)
			return
		end
		if char == CTRL_E then
			vim.api.nvim_win_call(win, function() vim.cmd('normal! ' .. CTRL_E) end)
			vim.cmd('redraw')
		elseif char == CTRL_Y then
			vim.api.nvim_win_call(win, function() vim.cmd('normal! ' .. CTRL_Y) end)
			vim.cmd('redraw')
		elseif char == CTRL_D then
			vim.api.nvim_win_call(win, function() vim.cmd('normal! 4' .. CTRL_E) end)
			vim.cmd('redraw')
		elseif char == CTRL_U then
			vim.api.nvim_win_call(win, function() vim.cmd('normal! 4' .. CTRL_Y) end)
			vim.cmd('redraw')
		else
			vim.api.nvim_win_close(win, true)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(get_sequence(char), true, false, true), mode, true)
			return
		end
	end
end

-- <C-r> lists
vim.keymap.set('n', '<C-r><C-t>', '<Cmd>tags<CR>', { silent = true })
vim.keymap.set('n', '<C-r><C-b>', '<Cmd>buffers<CR>', { silent = true })
vim.keymap.set('i', '<C-r><C-r>', function()
	open_registers_preview(function(char) return '<C-r>' .. char end, 'i')
end, { silent = true })
vim.keymap.set('n', '<C-r><C-r>', function()
	open_registers_preview(function(char) return '"' .. char .. 'P' end, 'n')
end, { silent = true })
vim.keymap.set('n', '<C-r><C-q>', function()
	open_registers_preview(function(char) return '@' .. char end, 'n')
end, { silent = true })
