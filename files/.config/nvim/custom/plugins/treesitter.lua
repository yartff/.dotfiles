---- basic configuration from treesitter readme
require("nvim-treesitter-textobjects").setup {
	select = {
		-- Automatically jump forward to textobj, similar to targets.vim
		lookahead = true,
		-- You can choose the select mode (default is charwise 'v')
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * method: eg 'v' or 'o'
		-- and should return the mode ('v', 'V', or '<c-v>') or a table
		-- mapping query_strings to modes.
		selection_modes = {
			['@parameter.outer'] = 'v', -- charwise
			['@function.outer'] = 'V', -- linewise
			-- ['@class.outer'] = '<c-v>', -- blockwise
		},
		-- If you set this to `true` (default is `false`) then any textobject is
		-- extended to include preceding or succeeding whitespace. Succeeding
		-- whitespace has priority in order to act similarly to eg the built-in
		-- `ap`.
		--
		-- Can also be a function which gets passed a table with the keys
		-- * query_string: eg '@function.inner'
		-- * selection_mode: eg 'v'
		-- and should return true of false
		include_surrounding_whitespace = false,
	},
}

local ctx = require("treesitter-context")
local ctx_max_lines = 1

local function ctx_setup()
	ctx.setup {
		enable = true,
		multiwindow = true,
		max_lines = ctx_max_lines,
		min_window_height = 0,
		line_numbers = true,
		multiline_threshold = 4,
		trim_scope = 'inner',
		mode = 'topline',
		separator = nil,
		zindex = 20,
		on_attach = nil,
	}
	vim.schedule(function()
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			vim.api.nvim_win_call(win, function()
				vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePost' })
			end)
		end
	end)
end
ctx_setup()

vim.keymap.set('n', '>C', function()
	ctx_max_lines = ctx_max_lines + 1
	ctx_setup()
	vim.notify('context max_lines: ' .. ctx_max_lines, vim.log.levels.INFO)
end, { silent = true })
vim.keymap.set('n', '<C', function()
	ctx_max_lines = math.max(1, ctx_max_lines - 1)
	ctx_setup()
	vim.notify('context max_lines: ' .. ctx_max_lines, vim.log.levels.INFO)
end, { silent = true })

-- treesitter-context's WinScrolled handler only updates the current window.
-- Re-fire it as a User event (which the plugin handles across all windows in multiwindow mode).
vim.api.nvim_create_autocmd("WinScrolled", {
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePost" })
	end,
})


-- keymaps
-- You can use the capture groups defined in `textobjects.scm`
vim.keymap.set({ "x", "o" }, "am", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "im", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ac", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
end)
vim.keymap.set({ "x", "o" }, "ic", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
end)
-- You can also use captures from other query groups like `locals.scm`
vim.keymap.set({ "x", "o" }, "as", function()
	require "nvim-treesitter-textobjects.select".select_textobject("@local.scope", "locals")
end)
