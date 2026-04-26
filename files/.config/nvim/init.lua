dofile(vim.fn.stdpath('config') .. '/loadcustoms.lua')

-- Runtime path
vim.opt.runtimepath:prepend(vim.fn.expand('~/.vim/bundle/ctrlp.vim'))


--[[
:help CTRL-]  
:help i_CTRL-X
:help v_CTRL-]
:help c_CTRL-R -- Command line

print customs:
:verbose map <C-w><BS>
:verbose nmap <C-w><BS>

:lua =vim.o.name
--]]

--[[
--  z (fold)
--  Q (Ex mode)
--  q (register)
--]]
