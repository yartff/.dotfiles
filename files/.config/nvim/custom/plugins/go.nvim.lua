require('go').setup {
  lsp_cfg = false,
}

--[[
vim.api.nvim_create_autocmd('BufWritePre', {
  group   = vim.api.nvim_create_augroup('GoImports', { clear = true }),
  pattern = '*.go',
  callback = function() vim.cmd.GoImports() end,
})

● The lspconfig's BufWritePre runs vim.lsp.buf.format for all LSP buffers. For Go, GoImports should run
  first (it handles both imports and formatting via goimports), making the subsequent LSP format a no-op.
  Since go.nvim is loaded alphabetically before nvim-lspconfig, the registration order is already correct.

● GoImports runs first (imports + format via goimports), then gopls's vim.lsp.buf.format runs second and
  finds nothing to change. Using pattern = '*.go' keeps it file-type scoped so it doesn't affect other LSP
  buffers.
--]]
