dofile(vim.fn.stdpath('config') .. '/loadcustoms.lua')

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
--]]
