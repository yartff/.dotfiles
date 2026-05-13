vim.o.shiftwidth  = 2

vim.o.breakindent = true
vim.o.scrolloff   = 6
vim.o.wrap        = false
vim.o.laststatus  = 2
vim.o.showcmd     = true
vim.o.showmode    = true
vim.o.number      = true
vim.o.cursorline  = true
vim.o.showmatch   = true
vim.o.matchtime   = 3

vim.o.splitright  = true
vim.o.splitbelow  = true
vim.o.equalalways = false

-- Status Bar
local _flash_timer = nil
local _flash_saved = nil

function _G.flash_statusline(color)
	if _flash_timer ~= nil then
		_flash_timer:stop()
		_flash_timer:close()
		_flash_timer = nil
	else
		_flash_saved = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
	end
	vim.api.nvim_set_hl(0, 'StatusLine', { bg = color or '#ff8800', fg = '#000000', bold = true })
	_flash_timer = vim.defer_fn(function()
		vim.api.nvim_set_hl(0, 'StatusLine', _flash_saved)
		_flash_timer = nil
		_flash_saved = nil
	end, 250)
end

function _G.withFlash_fileChange(fn)
	return function()
		local prev_buf = vim.api.nvim_get_current_buf()
		local au = vim.api.nvim_create_autocmd('BufEnter', {
			once = true,
			callback = function()
				if vim.api.nvim_get_current_buf() ~= prev_buf then _G.flash_statusline() end
			end,
		})
		vim.defer_fn(function() pcall(vim.api.nvim_del_autocmd, au) end, 500)
		fn()
	end
end

vim.keymap.set('n', '<RightMouse>', function()
	local pos = vim.fn.getmousepos()
	if pos.winid ~= 0 and pos.winrow > vim.api.nvim_win_get_height(pos.winid) then
		local path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(pos.winid))
		vim.fn.setreg('+', path)
		print('copied: ' .. path)
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<RightMouse>', true, false, true), 'n', true)
	end
end)

vim.o.statusline = [[%<%f %h%m%r%=T%{gettagstack().curidx-1}  %-16.(%l,%c /%L%) %P]]

-- vim.o.signcolumn = 'yes'
-- Colorcolumn: highlight columns 90-101
local cols = {}
for i = 90, 92 do cols[#cols + 1] = tostring(i) end
vim.opt.colorcolumn = table.concat(cols, ',')

-- Colorscheme
pcall(vim.cmd.colorscheme, 'railscasts')
vim.keymap.set('n', '<leader>k', function() pcall(vim.cmd.colorscheme, 'railscasts') end)
vim.keymap.set('n', '<leader>j', function() pcall(vim.cmd.colorscheme, 'claude') end)

-- Misc
vim.g.have_nerd_font = false
