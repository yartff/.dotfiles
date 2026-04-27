vim.opt.foldopen:remove('block')

local function fold_root_block()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  for i = row, 1, -1 do
    local line = vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]
    if not line:match('^%s') then
      if line:match('^/%*') then
        vim.api.nvim_win_set_cursor(0, { i, 0 })
        local end_r = vim.fn.search('\\*/', 'W')
        if end_r > 0 then
          vim.cmd(i .. ',' .. end_r .. 'fold')
          vim.api.nvim_win_set_cursor(0, { i, 0 })
        end
        return
      end
      local col = line:find('[{%[]')
      if col then
        vim.api.nvim_win_set_cursor(0, { i, col - 1 })
        vim.cmd('normal! zf%')
        return
      end
    end
  end
end

vim.keymap.set('n', 'zp', fold_root_block, { silent = true })
