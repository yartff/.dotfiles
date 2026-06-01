vim.opt.foldopen:remove('block')

vim.keymap.set('n', 'zt', 'za', { silent = true })
vim.keymap.set('n', 'zam', 'zfam', { silent = true, remap = true })

-- Unbinds
vim.keymap.set('n', 'za', '<Nop>')
vim.keymap.set('n', 'zi', '<Nop>')
