require('go').setup {
	lsp_cfg = false,
}

vim.api.nvim_create_autocmd('BufWritePre', {
	group    = vim.api.nvim_create_augroup('GoImports', { clear = true }),
	pattern  = '*.go',
	callback = function() vim.cmd.GoImports() end,
})
