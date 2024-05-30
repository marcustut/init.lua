vim.g.rustaceanvim = {
    server = {
        on_attach = function(_, bufnr)
            -- Hover actions
            vim.keymap.set("n", "K", vim.cmd.RustLsp { 'hover', 'actions' })

            -- Code action groups
            vim.keymap.set("n", "<leader>la", vim.cmd.RustLsp('codeAction'))

            -- Expand macro
            vim.keymap.set("n", "<leader>le", vim.cmd.RustLsp('expandMacro'))

            vim.keymap.set("n", "gd", vim.lsp.buf.definition)
            vim.keymap.set("n", "<leader>lws", vim.cmd.RustLsp('workspaceSymbol'))
            vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float)
            vim.keymap.set("n", "<leader>lj", vim.cmd.RustLsp('explainError'))
            vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev)
            vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format)
            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help)
            vim.keymap.set("n", "gr", vim.lsp.buf.references)

            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format { async = false }
                end
            })
        end
    }
}
