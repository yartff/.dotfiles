vim.cmd('hi clear')
if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
vim.g.colors_name = 'railscarb'
vim.o.background = 'dark'

local hi = function(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

local c = {
  -- UI
  bg_normal = "#121212",
  fg_normal = "#e4e4e4",
  bg_cursor = "#181818",
  fg_linenr = "#666666",
  fg_cursor_linenr = "#a0a0a0",
  fg_search = "#000000",
  bg_search = "#907515",
  bg_search_cur = "#cc9011",
  bg_color_column = '#1c1c1c',
  bg_visual = "#5f5f87",

  -- Borders
  fg_status = "#e4e4e4",
  bg_status = "#606060",
  fg_status_nc = "#909090",
  bg_status_nc = "#303030",
  fg_winsep = "#c0c0c0",

  -- Fold
  bg_folded = "#444470",

  -- Flash
  bg_yank_hl_flash = '#00afcc',

  -- Netwr
  fg_netwr_dir = "#3daee9",
  fg_netwr_exe = "#5fff00",
  fg_netwr_sym = "#00ffff",

  -- Pmenu
  fg_pmenu     = "#ffffff",
  bg_pmenu     = "#444444",
  fg_pmenu_sel = "#000000",
  bg_pmenu_sel = "#87af5f",
  bg_pmenu_bar = "#5a647e",
  fg_pmenu_thumb = "#ffffff",
  bg_pmenu_thumb = "#a8a8a8",

  -- Code constructs
  fg_comment    = "#949494",
  fg_todo       = "#df5f5f",
  fg_constant   = "#6d9cbe",
  bg_error      = "#990000",
  fg_warning    = "#800000",
  fg_identifier = "#af5f5f",
  fg_keyword    = "#af5f00",
  fg_number     = "#87af5f",
  fg_type       = "#df5f5f",
  fg_preproc    = "#ff8700",
  fg_special    = "#005f00",

  -- colors
  white = "#ffffff",
  red = "#ff0000",
  black = "#000000",

  none     = "NONE",
}

hi("Normal",        { fg = c.fg_normal, bg = c.bg_normal })
-- hi("NormalNC",        { fg = c.fg_normal, bg = c.bg_normal })
hi("Search",        { fg = c.fg_search, bg = c.bg_search })
hi("CurSearch",     { fg = c.fg_search, bg = c.bg_search_cur })
hi("Visual",        { bg = c.bg_visual })
hi("LineNr",        { fg = c.fg_linenr })
hi("Cursor",        { fg = c.black, bg = c.white })
hi("CursorLine",    { bg = c.bg_cursor })
hi("CursorLineNr",  { fg = c.fg_cursor_linenr })
hi("ColorColumn",   { bg = c.bg_color_column })
hi("WinSeparator",  { fg = c.fg_winsep })
hi("SignColumn",    { fg = c.white })
-- hi("CursorColumn",  { link = "ColorColumn" })
hi("YankHighlight",             { fg = c.black, bg = c.bg_yank_hl_flash })

-- StatusLine
hi("StatusLine",    { fg = c.fg_status, bg = c.bg_status })
hi("StatusLineNC",  { fg = c.fg_status_nc, bg = c.bg_status_nc })

-- Folds
hi("Folded",        { fg = c.white, bg = c.bg_folded })
-- hi("FoldColumn",    { fg = "#501010" })

-- Invisible characters
-- hi("NonText",       { fg = "#767676" })
-- hi("SpecialKey",    { fg = "#767676" })

-- netwr
hi("Directory",     { fg = c.fg_netwr_dir, bold = true })
hi("netrwExe",      { fg = c.fg_netwr_exe, bold = true })
hi("netrwSymLink",  { fg = c.fg_netwr_sym, bold = true })

-- Popup menu
hi("Pmenu",         { fg = c.fg_pmenu,       bg = c.bg_pmenu })
hi("PmenuSel",      { fg = c.fg_pmenu_sel,   bg = c.bg_pmenu_sel })
hi("PmenuSbar",     { bg = c.bg_pmenu_bar })
hi("PmenuThumb",    { fg = c.fg_pmenu_thumb, bg = c.bg_pmenu_thumb })

-- Code constructs
hi("Comment",       { fg = c.fg_comment })
hi("Todo",          { fg = c.fg_todo,       bold = true })
hi("Constant",      { fg = c.fg_constant })
hi("Error",         { fg = c.white,         bg = c.bg_error })
hi("WarningMsg",    { fg = c.fg_warning })
hi("Identifier",    { fg = c.fg_identifier })
hi("Keyword",       { fg = c.fg_keyword })
hi("Number",        { fg = c.fg_number })
hi("Statement",     { fg = c.fg_keyword })
hi("String",        { fg = c.fg_number })
hi("Title",         { fg = c.white })
hi("Type",          { fg = c.fg_type })
hi("PreProc",       { fg = c.fg_preproc })
hi("Special",       { fg = c.fg_special })
-- hi("Boolean",       { fg = c.copper, bold = true })

-- Diffs
hi("DiffAdd",       { fg = "#e4e4e4", bg = "#519f50" })
hi("DiffDelete",    { fg = c.black, bg = "#660000", bold = true })
hi("DiffChange",    { fg = c.white, bg = "#870087" })
hi("DiffText",      { fg = c.white, bg = "#ff0000", bold = true })
hi("Added",         { fg = "#00d000" })
hi("Removed",       { fg = "#d00000" })
hi("NewFile",       { fg = c.white, bold = true })
hi("diffFile",      { fg = "#6565aa", bold = true })


--[[ Mail
hi("mailEmail",                 { fg = "#87af5f", italic = true })
hi("mailHeaderKey",             { fg = "#ffdf5f" })
hi("mailSubject",               { link = "mailHeaderKey" })
--]]

-- Spell
hi("SpellBad",                  { fg = "#d70000", undercurl = true })
hi("SpellRare",                 { fg = "#df5f87", underline = true })
hi("SpellCap",                  { fg = "#dfdfff", underline = true })
hi("SpellLocal",                { fg = "#00ffff", undercurl = true })
hi("MatchParen",                { fg = c.white, bg = "#005f5f" })

--[[ XML / HTML
hi("xmlTag",                    { fg = "#dfaf5f" })
hi("xmlTagName",                { fg = "#dfaf5f" })
hi("xmlEndTag",                 { fg = "#dfaf5f" })
hi("htmlTag",                   { link = "xmlTag" })
hi("htmlTagName",               { link = "xmlTagName" })
hi("htmlEndTag",                { link = "xmlEndTag" })
--]]

--[[ Custom
hi("checkbox",                  { fg = "#3a3a3a" })
hi("checkboxDone",              { fg = "#5fff00", bold = true })
hi("checkboxNotDone",           { fg = "#005fdf", bold = true })
--]]
