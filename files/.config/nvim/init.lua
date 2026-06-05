-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.timeoutlen = 400

-- Load ./custom and ./custom/plugins
local dir = vim.fn.stdpath('config') .. '/custom/'
for _, path in ipairs(vim.fn.glob(dir .. 'plugins/*.lua', false, true)) do
	local ok, err = pcall(dofile, path)
	if not ok then
		vim.notify('Error loading ' .. path .. ': ' .. err, vim.log.levels.ERROR)
	end
end

for _, path in ipairs(vim.fn.glob(dir .. '*.lua', false, true)) do
	local ok, err = pcall(dofile, path)
	if not ok then
		vim.notify('Error loading ' .. path .. ': ' .. err, vim.log.levels.ERROR)
	end
end

--[[
:h CTRL-]
:h i_CTRL-X
:h v_CTRL-]
:h c_CTRL-R -- Command line

print customs:
:verbose map <C-w><BS>
:verbose nmap <C-w><BS>

:lua =vim.o.name
--]]

--[[ TODO's
--  Q (Ex mode)
--  Paste on select
--  Adding notes for files in sessions
--  Uniform <M-x> and <A-x> (both alt keys)
--  highlight TODO keyword
--  {'n', 'v'} '#' puts cursor at beginning of search
--  <leader><C-o> / <leader><C-i> to change files (replaces <leader>o / <leader>i )
--  add custom jump list and nav with <leader>o / <leader>i
--
--  Search:
--    Flash Status Red while typing in /
--    ? search without moving window? superseeded by terminal Ctrl-Shift-f
--
--  zh / zl, like zz, but for H and L (scroll)
--]]

--[[ Available keybinds
--
--  <C-w> h/j/k/l
--  zu
--
--]]

--[[ Nice to learn
--  ZZ/ZQ prefix (save+quit, quit)
### Tag / Definition Jumping
`:tnext` / `:tprev` | Next/prev tag match
`:tselect` | List all tag matches |
### LSP (Neovim native, `vim.lsp`)
--]]
