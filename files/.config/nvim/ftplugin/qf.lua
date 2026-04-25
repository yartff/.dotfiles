vim.api.nvim_set_hl(0, 'FlashLine', {
  reverse = true,
  ctermfg = 136,
  fg      = '#b58900',
})

vim.fn.sign_define('wholeline', { linehl = 'Visual' })

local function HighlightLine(duration)
  local line     = vim.fn.line('.')
  local winid    = vim.fn.win_getid()
  local match_id = vim.fn.matchaddpos('FlashLine', { { line } }, 100)
  vim.fn.timer_start(duration, function(_)
    vim.fn.win_execute(winid, 'call matchdelete(' .. match_id .. ')')
  end)
end

local buf = { buffer = true }

vim.keymap.set('n', '<C-w><CR>', '<C-w><CR> <C-w>w :lclose <CR>:lw <CR><CR>', buf)
vim.keymap.set('n', 'h', function()
  vim.cmd('normal! \r')
  HighlightLine(2000)
  vim.cmd('lopen')
end, buf)
vim.keymap.set('n', 'J', 'jh', { buffer = true, remap = true })
vim.keymap.set('n', 'K', 'kh', { buffer = true, remap = true })
vim.keymap.set('n', '<C-w><C-w>', '<C-w>c', buf)
