local here = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")

vim.keymap.set('n', 'd', '<C-d>', { noremap = true })
vim.keymap.set('n', 'u', '<C-u>', { noremap = true })

vim.opt.runtimepath:prepend(here .. '/../nvim')

dofile(here .. '/../nvim/custom/display.lua')
