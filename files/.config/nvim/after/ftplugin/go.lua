-- GoImports (go.nvim) already formats; remove the LSP BufWritePre format for this buffer.
vim.api.nvim_create_autocmd('LspAttach', {
	buffer   = 0,
	once     = true,
	callback = function(ev)
		pcall(vim.api.nvim_del_augroup_by_name, 'LspFormat.' .. ev.buf)
	end,
})
