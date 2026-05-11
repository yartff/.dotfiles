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
function _G.flash_statusline()
	local saved = vim.api.nvim_get_hl(0, { name = 'StatusLine' })
	vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#ff8800', fg = '#000000', bold = true })
	vim.defer_fn(function() vim.api.nvim_set_hl(0, 'StatusLine', saved) end, 250)
end

function _G.with_flash(fn)
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

function _G.StatuslineClick(_, _, button, _)
	if button == 'r' then
		local path = vim.fn.expand('%:p')
		vim.fn.setreg('+', path)
		print('copied: ' .. path)
	end
end

vim.o.statusline = [[%@v:lua.StatuslineClick@%<%f%X %h%m%r%=T%{gettagstack().curidx-1}  %-16.(%l,%c /%L%) %P]]

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
