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

--[[
--  <C-r>@			-> apply next <key> (check if Q redoes the same)
--  <C-r><C-r>	-> (in normal mode) Insert
--  ZZ/ZQ prefix (save+quit, quit)
--  Q (Ex mode)
--  Paste on select
--  Uniform <M-x> and <A-x> (both alt keys)
--  highlight TODO keyword
--]]

--[[
### Tag / Definition Jumping
| Key | Action |
|-----|--------|
| `Ctrl-w ]` | Open tag in horizontal split |
| `Ctrl-w }` | Preview tag in preview window |
| `:tnext` / `:tprev` | Next/prev tag match |
| `:tselect` | List all tag matches |
### LSP (Neovim native, `vim.lsp`)
| Key | Action |
|-----|--------|
| `Ctrl-k` | `vim.lsp.buf.signature_help()` |
| `gq` (on range) | Format via LSP |
For Go/C/C++ specifically, **ctags** (`Ctrl-]`) covers most cases without LSP, but pairing with `clangd` or `gopls` via the native LSP client gives you the full `gd`/`gr`/`gi` suite with no plugins required.
--]]
--
-- TODOs:
