local dir = vim.fn.stdpath('config') .. '/custom/'
for _, name in ipairs({ 'system', 'lsp', 'display', 'keybinds', 'filetype', 'fold', 'functions' }) do
  dofile(dir .. name .. '.lua')
end
for _, path in ipairs(vim.fn.glob(dir .. 'plugins/*.lua', false, true)) do
  dofile(path)
end

-- Runtime path
vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim/bundle/ctrlp.vim'))


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
--  yap/vap
--  z (fold)
--  Q (Ex mode)
--  q (register)
--  ZZ/ZQ prefix (save+quit, quit)
--]]
--
--[[
-- Code Nav
--   
-- <C-n> Jump to tag		| <C-]>
-- <C-n> Jumb back		| <C-t> X
-- gd	Go to local decl
-- gd	Go to global decl
-- ga	print 
--]]
--
