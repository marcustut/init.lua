vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(args)
        -- Helper function to map keybinds
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = 'LSP: ' .. desc })
        end

        -- Common keybinds
        map("gd", require("telescope.builtin").lsp_definitions, '[G]oto [D]efinition')
        map("gr", require("telescope.builtin").lsp_references, '[G]oto [R]eferences')
        map("K", vim.lsp.buf.hover, 'Hover')
        map("<leader>ls", require("telescope.builtin").lsp_document_symbols, 'List [S]ymbols')
        map("<leader>lws", require("telescope.builtin").lsp_dynamic_workspace_symbols, 'List [W]orkspace [S]ymbols')
        map("<leader>ld", vim.diagnostic.open_float, 'List [D]iagnostics')
        map("<leader>lj", function() vim.diagnostic.jump({ count = 1, float = true }) end, 'Next Diagnostic')
        map("<leader>lk", function() vim.diagnostic.jump({ count = -1, float = true }) end, 'Previous Diagnostic')
        map("<leader>la", vim.lsp.buf.code_action, 'Code [A]ction')
        map("<leader>lr", vim.lsp.buf.rename, '[R]ename')
        map("<C-h>", vim.lsp.buf.signature_help, 'Signature [H]elp', 'i')

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, args.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = args.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = args.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(event)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event.buf }
                end,
            })
        end

        -- Creates a keymap to toggle inlay hints if the language server supports them
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, args.buf) then
            map('<leader>lh', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = args.buf })
            end, 'Toggle Inlay [H]ints')
        end
    end
})


-- Diagnostic Config
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    underline = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
    },
    virtual_text = {
        source = "if_many",
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
})

-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Nix files
vim.lsp.config("nil_ls", {
    capabilities = capabilities,
    settings = {
        ["nil"] = { formatting = { command = { "nixpkgs-fmt" } } },
    },
})

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls" },
    automatic_enable = {
        exclude = { "rust_analyzer" }
    },
})
