-- ── AUTOCMDS ──────────────────────────────────────────────────────────────────
local augroup = vim.api.nvim_create_augroup('vimrc', { clear = true })

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  group    = augroup,
  pattern  = '*.tpp',
  callback = function() vim.bo.filetype = 'cpp' end,
})
