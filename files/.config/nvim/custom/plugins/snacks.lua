require('snacks').setup {
  scope        = { enabled = true },  -- treesitter/indent scope detection
--[[
  animate      = { enabled = true },  -- animation primitives (used by others)
  bigfile      = { enabled = true },  -- disable features for large files
  dashboard    = { enabled = true },  -- start screen
  dim          = { enabled = true },  -- dim inactive code
  explorer     = { enabled = true },  -- file explorer (picker-based, replaces netrw)
  gh           = { enabled = true },  -- GitHub issues/PRs integration
  gitbrowse    = { enabled = true },  -- open file/line in browser (GitHub etc.)
  image        = { enabled = true },  -- inline image preview
  indent       = { enabled = true },  -- indent guides
  input        = { enabled = true },  -- better vim.ui.input
  layout       = { enabled = true },  -- window layout primitives
  lazygit      = { enabled = true },  -- lazygit integration
  notifier     = { enabled = true },  -- better notifications
  picker       = { enabled = true },  -- fuzzy finder (telescope replacement)
  profiler     = { enabled = true },  -- Lua profiler
  quickfile    = { enabled = true },  -- fast file opening
  scratch      = { enabled = true },  -- scratch buffers
  scroll       = { enabled = true },  -- smooth scrolling
  statuscolumn = { enabled = true },  -- pretty status column
  terminal     = { enabled = true },  -- floating/split terminal
  toggle       = { enabled = true },  -- toggleable keymaps
  win          = { enabled = true },  -- window/float management primitives
  words        = { enabled = true },  -- highlight LSP references under cursor
  zen          = { enabled = true },  -- zen/distraction-free mode
--]]
}
