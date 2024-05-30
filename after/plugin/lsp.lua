local lsp = require('lsp-zero')

lsp.preset('recommended')

-- Configure auto completion
local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    mapping = cmp.mapping.preset.insert({
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
        ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-Space>'] = cmp.mapping.complete(),
    }),
})

-- Configure diagnostics annotations in sign column
lsp.set_preferences({
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
    vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

    -- Toggle inlay hints
    if client.server_capabilities.inlayHintProvider then
        vim.keymap.set("n", "<leader>h", function()
            local current_setting = vim.lsp.inlay_hint.is_enabled(bufnr)
            vim.lsp.inlay_hint.enable(bufnr, not current_setting)
        end)
    end

    -- Format on save
    local group = vim.api.nvim_create_augroup("Format on save", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        group = group,
        callback = function()
            if client.name == 'pyright' then -- Use black to format Python
                vim.cmd("write")
                vim.cmd("silent !black %")
                vim.cmd("edit!")
                print("formatted")
            elseif client.name == 'copilot' then -- Copilot does not need format on save
            else                                 -- Fallback to LSP default formatter
                vim.lsp.buf.format { async = false }
            end
        end,
    })
end)

-- Configure Mason auto install language servers
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { 'lua_ls', 'tsserver', 'eslint' },
    handlers = {
        lsp.default_setup,

        -- Disable lspconfig for rust since we use rustaceanvim
        rust_analyzer = function() end,

        -- Configure clangd (for C/C++)
        clangd = function()
            require('lspconfig').clangd.setup({})
        end,

        -- Configure Lua
        lua_ls = function()
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { 'vim' }
                        }
                    }
                }
            })
        end,

        -- Disable typescript's default formatter
        tsserver = function()
            require('lspconfig').tsserver.setup({
                on_init = function(client, _)
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentFormattingRangeProvider = false
                end
            })
        end,

        -- Add eslint fix all on save
        eslint = function()
            require('lspconfig').eslint.setup({
                on_attach = function(client, _)
                    client.server_capabilities.documentFormattingProvider = true
                end
            })
        end,
    }
})

lsp.setup()

vim.diagnostic.config({ virtual_text = true })
