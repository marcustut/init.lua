local rt = require('rust-tools')
local expand_macro = require('rust-tools.expand_macro')

rt.setup({
    server = {
        on_attach = function(_, bufnr)
            local opts = { buffer = bufnr, remap = false }

            -- Hover actions
            vim.keymap.set("n", "K", rt.hover_actions.hover_actions, opts)

            -- Code action groups
            vim.keymap.set("n", "<leader>la", rt.code_action_group.code_action_group, opts)

            -- Expand macro
            vim.keymap.set("n", "<leader>le", expand_macro.expand_macro)

            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "<leader>lws", vim.lsp.buf.workspace_symbol, opts)
            vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, opts)
            vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, opts)
            vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format { async = false }
                end
            })
        end,
        diagnostic = {
            enable = true,
            disabled = { "unresolved-proc-macro" },
            enableExperimental = true
        }
    }
})
