local sessions_dir = vim.fn.expand('$HOME/.sessions')

vim.api.nvim_create_user_command('Mk', function(opts)
	if #opts.fargs ~= 1 then
		vim.notify(':Mk requires exactly one argument', vim.log.levels.ERROR)
		return
	end
	local name = opts.fargs[1]
	vim.fn.mkdir(sessions_dir, 'p')
	vim.cmd('mksession! ' .. sessions_dir .. '/' .. name .. '.vim')
end, {
	nargs = '*',
	complete = function(arglead)
		local files = vim.fn.glob(sessions_dir .. '/*.vim', false, true)
		local names = {}
		for _, f in ipairs(files) do
			local name = vim.fn.fnamemodify(f, ':t:r')
			if name:find('^' .. vim.pesc(arglead)) then
				table.insert(names, name)
			end
		end
		return names
	end,
})
