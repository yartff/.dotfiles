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
--  ZZ/ZQ prefix (save+quit, quit)
--]]
--
--[[
-- Code Nav
--   
-- <C-n> Jump to tag		| <C-]>
-- <C-n> Jumb back		| <C-t> X
-- gd	Go to local decl
-- gd	Go to global decl
-- ga	print 
--]]


--[[
require('goto-preview').setup {
  width = 120, -- Width of the floating window
  height = 15, -- Height of the floating window
  border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}, -- Border characters of the floating window
  default_mappings = false, -- Bind default mappings
  debug = false, -- Print debug information
  opacity = nil, -- 0-100 opacity level of the floating window where 100 is fully transparent.
  resizing_mappings = false, -- Binds arrow keys to resizing the floating window.
  post_open_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  post_close_hook = nil, -- A function taking two arguments, a buffer and a window to be ran as a hook.
  -- references = { -- Configure the telescope UI for slowing the references cycling window.
  --   provider = "telescope", -- telescope|fzf_lua|snacks|mini_pick|default
  --   telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
  -- },

  -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
  focus_on_open = true, -- Focus the floating window when opening it.
  dismiss_on_move = false, -- Dismiss the floating window when moving the cursor.
  force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
  stack_floating_preview_windows = true, -- Whether to nest floating windows
  same_file_float_preview = true, -- Whether to open a new floating window for a reference within the current file
  preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
  zindex = 1, -- Starting zindex for the stack of floating windows
  vim_ui_input = true, -- Whether to override vim.ui.input with a goto-preview floating window
}

local gp = require('goto-preview')
vim.keymap.set('n', 'gpd', gp.goto_preview_definition)
vim.keymap.set('n', 'gpt', gp.goto_preview_type_definition)
vim.keymap.set('n', 'gpi', gp.goto_preview_implementation)
vim.keymap.set('n', 'gpD', gp.goto_preview_declaration)
vim.keymap.set('n', 'gP',  gp.close_all_win)
vim.keymap.set('n', 'gpr', gp.goto_preview_references)
--]]
