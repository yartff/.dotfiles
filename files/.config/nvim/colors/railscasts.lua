-- https://github.com/jpo/vim-railscasts-theme

vim.o.background = 'dark'
vim.cmd('highlight clear')
vim.g.colors_name = 'railscasts'

local hi = function(name, opts)
  vim.api.nvim_set_hl(0, name, opts)
end

hi('Normal',        { fg = '#e4e4e4', bg = '#121212' })
hi('Search',        { fg = '#000000', bg = '#5f5f87' })
hi('Visual',        { bg = '#5f5f87' })
hi('LineNr',        { fg = '#666666' })
hi('Cursor',        { fg = '#000000', bg = '#ffffff' })
hi('CursorLine',    { bg = '#1c1c1c' })
hi('CursorLineNr',  { fg = '#a9a8a8' })
hi('ColorColumn',   { bg = '#1c1c1c' })
hi('CursorColumn',  { link = 'ColorColumn' })
hi('VertSplit',     { fg = '#444444', bg = '#121212' })
hi('SignColumn',    { fg = '#ffffff' })

-- StatusLine
hi('User1',         { fg = '#eeeeee', bg = '#606060', bold = true }) -- Bold
hi('User2',         { fg = '#ffaf00', bg = '#606060', bold = true }) -- Yellow
hi('User3',         { fg = '#5fff00', bg = '#606060', bold = true }) -- Green
hi('User4',         { fg = '#870000', bg = '#606060', bold = true }) -- Red
hi('User5',         { fg = '#e4e4e4', bg = '#606060', bold = true })
hi('User6',         { fg = '#e4e4e4', bg = '#606060', bold = true })
hi('User7',         { fg = '#e4e4e4', bg = '#606060', bold = true })
hi('User8',         { fg = '#e4e4e4', bg = '#606060', bold = true })
hi('User9',         { fg = '#e4e4e4', bg = '#606060', bold = true })
hi('StatusLine',    { fg = '#e4e4e4', bg = '#606060' })
hi('StatusLineNC',  { fg = '#585858', bg = '#303030' })

-- Folds
hi('Folded',        { fg = '#ffffff', bg = '#444444' })
hi('FoldColumn',    { link = 'SignColumn' })

-- Invisible characters
hi('NonText',       { fg = '#767676' })
hi('SpecialKey',    { fg = '#767676' })

-- Misc
hi('Directory',     { fg = '#87af5f' })

-- Popup menu
hi('Pmenu',         { fg = '#ffffff', bg = '#444444' })
hi('PmenuSel',      { fg = '#000000', bg = '#87af5f' })
hi('PmenuSbar',     { bg = '#5a647e' })
hi('PmenuThumb',    { fg = '#ffffff', bg = '#a8a8a8' })

-- Code constructs
hi('Comment',       { fg = '#949494' })
hi('Todo',          { fg = '#df5f5f', bold = true })
hi('Constant',      { fg = '#6d9cbe' })
hi('Error',         { fg = '#ffffff', bg = '#990000' })
hi('WarningMsg',    { fg = '#800000' })
hi('Identifier',    { fg = '#af5f5f' })
hi('Keyword',       { fg = '#af5f00' })
hi('Number',        { fg = '#87af5f' })
hi('Statement',     { fg = '#af5f00' })
hi('String',        { fg = '#87af5f' })
hi('Title',         { fg = '#ffffff' })
hi('Type',          { fg = '#df5f5f' })
hi('PreProc',       { fg = '#ff8700' })
hi('Special',       { fg = '#005f00' })

-- Diffs
hi('DiffAdd',       { fg = '#e4e4e4', bg = '#519f50' })
hi('DiffDelete',    { fg = '#000000', bg = '#660000', bold = true })
hi('DiffChange',    { fg = '#ffffff', bg = '#870087' })
hi('DiffText',      { fg = '#ffffff', bg = '#ff0000', bold = true })
hi('diffAdded',     { fg = '#008700' })
hi('diffRemoved',   { fg = '#800000' })
hi('diffNewFile',   { fg = '#ffffff', bold = true })
hi('diffFile',      { fg = '#ffffff', bold = true })

-- Ruby
hi('rubyTodo',                  { fg = '#df5f5f', bold = true })
hi('rubyClass',                 { fg = '#ffffff' })
hi('rubyConstant',              { fg = '#df5f5f' })
hi('rubyInterpolation',         { fg = '#ffffff' })
hi('rubyBlockParameter',        { fg = '#dfdfff' })
hi('rubyPseudoVariable',        { fg = '#ffdf5f' })
hi('rubyStringDelimiter',       { fg = '#87af5f' })
hi('rubyInstanceVariable',      { fg = '#dfdfff' })
hi('rubyPredefinedConstant',    { fg = '#df5f5f' })
hi('rubyLocalVariableOrMethod', { fg = '#dfdfff' })

-- Python
hi('pythonExceptions',          { fg = '#ffaf87' })
hi('pythonDoctest',             { fg = '#8787ff' })
hi('pythonDoctestValue',        { fg = '#87d7af' })

-- Mail
hi('mailEmail',                 { fg = '#87af5f', italic = true })
hi('mailHeaderKey',             { fg = '#ffdf5f' })
hi('mailSubject',               { link = 'mailHeaderKey' })

-- Spell
hi('SpellBad',                  { fg = '#d70000', undercurl = true })
hi('SpellRare',                 { fg = '#df5f87', underline = true })
hi('SpellCap',                  { fg = '#dfdfff', underline = true })
hi('SpellLocal',                { fg = '#00ffff', undercurl = true })
hi('MatchParen',                { fg = '#ffffff', bg = '#005f5f' })

-- XML / HTML
hi('xmlTag',                    { fg = '#dfaf5f' })
hi('xmlTagName',                { fg = '#dfaf5f' })
hi('xmlEndTag',                 { fg = '#dfaf5f' })
hi('htmlTag',                   { link = 'xmlTag' })
hi('htmlTagName',               { link = 'xmlTagName' })
hi('htmlEndTag',                { link = 'xmlEndTag' })

-- Custom
hi('checkbox',                  { fg = '#3a3a3a' })
hi('checkboxDone',              { fg = '#5fff00', bold = true })
hi('checkboxNotDone',           { fg = '#005fdf', bold = true })
