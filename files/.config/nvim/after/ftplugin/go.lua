--[[
vim.bo.omnifunc = 'go#complete#Complete'

vim.opt_local.tabstop = 2
vim.opt_local.completeopt:remove('preview')

vim.g.go_highlight_space_tab_error           = 0
vim.g.go_highlight_array_whitespace_error    = 0
vim.g.go_highlight_trailing_whitespace_error = 0
vim.g.go_doc_max_height                      = 20

local function Go_DefinitionWindow(mode)
  vim.fn['go#def#Jump'](mode, 0)
end

local buf = { buffer = true, silent = true }

vim.keymap.set('n', '<C-w><C-n>', function() Go_DefinitionWindow('vsplit') end,          buf)
vim.keymap.set('n', '<C-w>n',     function() Go_DefinitionWindow('split') end,           buf)
vim.keymap.set('n', '<C-w>N',     function() vim.cmd('tab split') vim.cmd.GoDef() end,   buf)
vim.keymap.set('n', 'g<C-d>',     function() vim.fn['go#def#Jump']('split', 1) end,      buf)
vim.keymap.set('n', 'gc',         '<Cmd>GoCallers<CR>',    buf)

vim.keymap.set('n', '-',          '<Cmd>GoDecls<CR>',      buf)
vim.keymap.set('n', '_',          '<Cmd>GoDeclsDir<CR>',   buf)
vim.keymap.set('n', '&',          '<Cmd>GoSameIds<CR>',    buf)
vim.keymap.set('n', 'g&',         '<Cmd>GoSameIdsClear<CR>', buf)

-- <C-n>: trigger omnifunc if popup not visible, advance selection if it is
vim.keymap.set('i', '<C-n>', function()
  if vim.fn.pumvisible() ~= 0 then
    return vim.api.nvim_replace_termcodes('<C-n>', true, false, true)
  else
    return vim.api.nvim_replace_termcodes('<C-x><C-o>', true, false, true)
  end
end, { buffer = true, expr = true })
--]]

--[[
-- global settings applied to ALL language servers
vim.lsp.config('*', {

    -- richer completion capabilities (if you use nvim-cmp)
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
})
--]]

-- enable gopls — nvim-lspconfig provides the base config,
-- lsp/gopls.lua above merges on top of it
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
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,       opts)

        vim.keymap.set('n', 'gy',         vim.lsp.buf.declaration,   opts)
        vim.keymap.set('i', '<C-k>',      vim.lsp.buf.signature_help,    opts)

	-- vim.keymap.set('i', '<C-n>', vim.lsp.completion.trigger, opts)

	--[[ Format ]]
        vim.keymap.set('n', '<leader>f',  function()
            vim.lsp.buf.format({ async = true })
        end, opts)
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = ev.buf,
            callback = function()
                vim.lsp.buf.format({ async = false, bufnr = ev.buf })
            end,
        })

	--[[ Diagnostic ]]
        vim.keymap.set('n', '<leader>e',  vim.diagnostic.open_float,    opts)
        vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,     opts)
        vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,     opts)
        vim.keymap.set('n', '<leader>q',  vim.diagnostic.setloclist,    opts)
        vim.keymap.set('n', '<leader>ds', vim.lsp.buf.document_symbol,  opts)
        -- vim.keymap.set('n', '<leader>ws', vim.lsp.buf.workspace_symbol, opts)

    end,
})

-- diagnostic display
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
