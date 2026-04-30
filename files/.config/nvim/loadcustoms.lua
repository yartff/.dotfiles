local dir = vim.fn.stdpath('config') .. '/custom/'
for _, name in ipairs({ 'system', 'display', 'keybinds', 'filetype', 'fold', 'functions' }) do
  dofile(dir .. name .. '.lua')
end
