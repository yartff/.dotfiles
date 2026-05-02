vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,       opts)
    vim.keymap.set('n', '<C-n>',      vim.lsp.buf.definition,       opts)
    vim.keymap.set('n', 'gD',         vim.lsp.buf.type_definition,       opts)
    vim.keymap.set('n', 'gi',         vim.lsp.buf.implementation,    opts)
    vim.keymap.set('n', 'gr',         vim.lsp.buf.references,        opts)
    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,             opts)

    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,            opts)

    vim.keymap.set('n', 'gy',         vim.lsp.buf.declaration,   opts)
    -- vim.keymap.set('i', '<C-k>',      vim.lsp.buf.signature_help,    opts) -- TODO: doesn't work

    vim.keymap.set('i', '<C-n>', vim.lsp.completion._omnifunc, opts)

    --[[ Format ]]
    vim.keymap.set('n', '<leader>f',  function()
      vim.lsp.buf.format({ async = true })
    end, opts)

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. ev.buf, { clear = true }),
      buffer = ev.buf,
      callback = function()
	vim.lsp.buf.format({ async = false, bufnr = ev.buf })
      end,
    })

    --[[ Diagnostic ]]
    vim.keymap.set('n', '<leader>d',  vim.diagnostic.open_float,    opts)
    vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,     opts)
    vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,     opts)
    vim.keymap.set('n', '<leader>q',  vim.diagnostic.setloclist,    opts)
    --[[ buf ]]
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,       opts)
    vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol,  opts)
    -- vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)

    -- Untested on other LSPs
    -- list all symbols in current document (functions, types, vars)
    vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol, opts)

    -- search symbols across the entire workspace
    vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)

    -- add workspace folder (for multi-module repos)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
  end,

  -- diagnostic display
  --[[
  vim.diagnostic.config({
    virtual_text    = true,
    update_in_insert = false,
    severity_sort   = true,
    signs           = true,
    underline       = true,
    float = {
      border = 'rounded',
      source = true,
    },
  })
  --]]

  --[[
  {
    -- to add:
    incoming_calls = <function 13>,
    outgoing_calls = <function 15>,

    -- already here but figure out
    signature_help = <function 20>,
    code_action = <function 3>,
    document_symbol = <function 8>,
    add_workspace_folder = <function 1>,
    list_workspace_folders = <function 14>,
    remove_workspace_folder = <function 17>,
    workspace_symbol = <function 24>

    -- absent
    clear_references = <function 2>,
    document_highlight = <function 7>,
    execute_command = <function 9>,
    selection_range = <function 19>,
    typehierarchy = <function 22>,
    workspace_diagnostics = <function 23>,
  }
  --]]

})
