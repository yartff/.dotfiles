vim.lsp.config('gopls', {
  settings = {
    gopls = {
      buildFlags = { "-tags=testing" },
    },
  },
})

vim.lsp.enable('gopls')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    --[[ Go-To ]]
    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,       opts)
    vim.keymap.set('n', '<C-n>',      vim.lsp.buf.definition,       opts)
    vim.keymap.set('n', 'gD',         vim.lsp.buf.type_definition,       opts)
    vim.keymap.set('n', 'gi',         vim.lsp.buf.implementation,    opts)
    vim.keymap.set('n', 'gr',         vim.lsp.buf.references,        opts)
    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,             opts)
    -- gt available

    -- vim.keymap.set('n', 'gy',         vim.lsp.buf.declaration,   opts) -- TODO: doesn't work
    -- vim.keymap.set('i', '<C-k>',      vim.lsp.buf.signature_help,    opts) -- TODO: doesn't work
    vim.keymap.set('i', '<C-n>', vim.lsp.completion._omnifunc, opts)

    local function goto_definition(split)
      local params = vim.lsp.util.make_position_params(0, 'utf-16')
      vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result)
        if err or not result or vim.tbl_isempty(result) then return end
        local location = result[1] or result
        local uri   = location.uri or location.targetUri
        local range = location.range or location.targetSelectionRange
        vim.cmd(split .. ' ' .. vim.fn.fnameescape(vim.uri_to_fname(uri)))
        if range then
          vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
        end
      end)
    end

    vim.keymap.set('n', '<C-w><C-n>', function() goto_definition('vsplit')  end, opts)
    vim.keymap.set('n', '<C-w>n',     function() goto_definition('split')  end, opts)
    vim.keymap.set('n', '<C-w>N',     function() goto_definition('tabedit') end, opts)
    vim.keymap.set('n', '<leader>gn', function() vim.lsp.buf.definition({      reuse_win = true }) end, opts)
    vim.keymap.set('n', '<leader>gN', function() vim.lsp.buf.type_definition({ reuse_win = true }) end, opts)

    --[[ Preview ]]
    local gp = require('goto-preview')
    vim.keymap.set('n', '<leader>gd', gp.goto_preview_definition)
    vim.keymap.set('n', '<leader>gD', gp.goto_preview_type_definition)
    -- vim.keymap.set('n', '<leader>gi', gp.goto_preview_implementation) -- TODO: make preview in quickfix list
    -- vim.keymap.set('n', '<leader>gr', gp.goto_preview_references)     -- TODO: make preview in quickfix list
    -- vim.keymap.set('n', '<leader>gy', gp.goto_preview_declaration)    -- TODO: with regular gy
    vim.keymap.set('n', 'qq',         gp.close_all_win)

    --[[ Format ]]
    vim.keymap.set('n', '<leader>f',  function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat.' .. ev.buf, { clear = true }),
      buffer = ev.buf,
      callback = function()
	vim.lsp.buf.format({ async = false, bufnr = ev.buf })
      end,
    })

    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)

    --[[ Diagnostic ]]
    vim.diagnostic.enable(false)
    vim.keymap.set('n', '<leader>d', function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end)
    vim.keymap.set('n', '<leader>e',  vim.diagnostic.open_float,    opts)
    vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,     opts)
    vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,     opts)
    vim.keymap.set('n', '<leader>q',  vim.diagnostic.setloclist,    opts)

    --[[ buf ]]
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,      opts)
    vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol,  opts)

    -- [[ Workspace ]]
    vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
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
