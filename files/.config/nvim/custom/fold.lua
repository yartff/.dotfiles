vim.opt.foldopen:remove('block')

local function find_root_block()
  local saved = vim.api.nvim_win_get_cursor(0)
  local row = saved[1]
  for i = row, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if not line:match('^%s') then
      if line:match('^/%*') then
        vim.api.nvim_win_set_cursor(0, { i, 0 })
        local end_r = vim.fn.search('\\*/', 'Wn')
        vim.api.nvim_win_set_cursor(0, saved)
        if end_r > 0 then return i, end_r end
        return
      end
      local col = line:find('[{%[]')
      if col then
        local open    = line:sub(col, col)
        local close   = open == '{' and '}' or ']'
        local pat_open = open == '[' and '\\[' or open  -- [ is magic in Vim patterns
        vim.api.nvim_win_set_cursor(0, { i, col - 1 })
        local end_pos = vim.fn.searchpairpos(pat_open, '', close, 'nW')
        vim.api.nvim_win_set_cursor(0, saved)
        if end_pos[1] > 0 then return i, end_pos[1] end
        return
      end
    end
  end
end

vim.keymap.set('n', 'zp', function()
  local start, end_r = find_root_block()
  if not start then return end
  vim.cmd(start .. ',' .. end_r .. 'fold')
  vim.api.nvim_win_set_cursor(0, { start, 0 })
end, { silent = true })

vim.keymap.set('o', 'ap', function()
  local start, end_r = find_root_block()
  if not start then return end
  vim.cmd('normal! ' .. start .. 'GV' .. end_r .. 'G')
end, { silent = true })

vim.keymap.set('x', 'ap', function()
  local start, end_r = find_root_block()
  if not start then return end
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes('<Esc>' .. start .. 'GV' .. end_r .. 'G', true, true, true),
    'x', false
  )
end, { silent = true })

vim.keymap.set('n', 'zt', 'za', { silent = true })
