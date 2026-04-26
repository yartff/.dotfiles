vim.api.nvim_set_hl(0, 'FlashLine', {
  reverse = true,
  ctermfg = 136,
  fg      = '#b58900',
})

vim.fn.sign_define('wholeline', { linehl = 'Visual' })

local function HighlightLine(duration)
  local line     = vim.api.nvim_win_get_cursor(0)[1]
  local winid    = vim.api.nvim_get_current_win()
  local match_id = vim.fn.matchaddpos('FlashLine', { { line } }, 100)
  vim.defer_fn(function()
    vim.api.nvim_win_call(winid, function() vim.fn.matchdelete(match_id) end)
  end, duration)
end

local buf = { buffer = true }

vim.keymap.set('n', '<C-w><CR>', '<C-w><CR><C-w>w<Cmd>lclose<CR><Cmd>lwindow<CR><CR>', buf)
vim.keymap.set('n', 'h', function()
  vim.cmd('normal! \r')
  HighlightLine(2000)
  vim.cmd.lopen()
end, buf)
vim.keymap.set('n', 'J', 'jh', { buffer = true, remap = true })
vim.keymap.set('n', 'K', 'kh', { buffer = true, remap = true })
vim.keymap.set('n', '<C-w><C-w>', '<C-w>c', buf)
