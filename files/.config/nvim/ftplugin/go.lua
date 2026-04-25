vim.bo.omnifunc = 'go#complete#Complete'

vim.opt_local.tabstop = 2
vim.opt_local.completeopt:remove('preview')

vim.g.go_highlight_space_tab_error           = 0
vim.g.go_highlight_array_whitespace_error    = 0
vim.g.go_highlight_trailing_whitespace_error = 0
vim.g.go_doc_max_height                      = 20

local function Go_DefinitionWindow(mode)
  if mode == 'split' then
    vim.cmd('split')
  elseif mode == 'vsplit' then
    vim.cmd('vsplit')
  end
  vim.cmd('wincmd w')
  vim.cmd('GoDef')
end

local buf = { buffer = true, silent = true }

vim.keymap.set('n', '<C-n>',      ':GoDef<CR>',                                        buf)
vim.keymap.set('n', '<C-w><C-n>', function() Go_DefinitionWindow('vsplit') end,         buf)
vim.keymap.set('n', '<C-w>n',     function() Go_DefinitionWindow('split') end,          buf)
vim.keymap.set('n', '<C-w>N',     function() vim.fn['go#def#Jump']('tab', 0) end,       buf)
vim.keymap.set('n', 'g<C-d>',     function() vim.fn['go#def#Jump']('split', 1) end,     buf)
vim.keymap.set('n', 'gd',         ':GoInfo<CR>',        buf)
vim.keymap.set('n', '<C-m>',      ':GoCallers<CR>',     buf)
vim.keymap.set('n', 'g<C-m>',     ':GoReferrers<CR>',   buf)
vim.keymap.set('n', '<C-g>',      ':GoImplements<CR>',  buf)
vim.keymap.set('n', '-',          ':GoDecls<CR>',       buf)
vim.keymap.set('n', '_',          ':GoDeclsDir<CR>',    buf)
vim.keymap.set('n', '&',          ':GoSameIds<CR>',     buf)
vim.keymap.set('n', 'g&',         ':GoSameIdsClear<CR>',buf)

-- <C-n>: trigger omnifunc if popup not visible, advance selection if it is
vim.keymap.set('i', '<C-n>', function()
  if vim.fn.pumvisible() ~= 0 then
    return vim.api.nvim_replace_termcodes('<C-n>', true, false, true)
  else
    return vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true)
  end
end, { buffer = true, expr = true })
