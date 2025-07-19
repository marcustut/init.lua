vim.g.rustaceanvim = {
    server = {
        on_attach = function(client, bufnr)
            local opts = { buffer = bufnr, remap = false }

            -- Flycheck
            vim.keymap.set("n", "<leader>lc", function()
                vim.cmd.RustLsp("flyCheck")
            end, opts)

            -- Expand macro
            vim.keymap.set("n", "<leader>le", function()
                vim.cmd.RustLsp("expandMacro")
            end, opts)

            vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
            vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
            vim.keymap.set("n", "K", function()
                vim.cmd.RustLsp({ "hover", "actions" })
            end, opts)
            vim.keymap.set("n", "<leader>lws", function()
                vim.cmd.RustLsp("workspaceSymbol")
            end, opts)
            vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)
            vim.keymap.set("n", "<leader>lj", function()
                vim.cmd.RustLsp({ "explainError", "cycle" })
            end, opts)
            vim.keymap.set("n", "<leader>lk", function()
                vim.cmd.RustLsp({ "explainError", "cycle_prev" })
            end, opts)
            vim.keymap.set("n", "<leader>la", function()
                vim.cmd.RustLsp("codeAction")
            end, opts)
            vim.keymap.set("n", "<leader>lf", function() require("conform").format({ async = true }) end, opts)
            vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

            -- Toggle inlay hints
            if client.server_capabilities.inlayHintProvider then
                vim.keymap.set("n", "<leader>h", function()
                    local current_setting = vim.lsp.inlay_hint.is_enabled()
                    vim.lsp.inlay_hint.enable(not current_setting)
                end)
            end

            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function() require("conform").format({ async = true }) end,
            })
        end,
        settings = {
            ["rust-analyzer"] = {
                inlayHints = {
                    bindingModeHints = {
                        enable = false,
                    },
                    chainingHints = {
                        enable = true,
                    },
                    closingBraceHints = {
                        enable = true,
                        minLines = 25,
                    },
                    closureReturnTypeHints = {
                        enable = "never",
                    },
                    lifetimeElisionHints = {
                        enable = "never",
                        useParameterNames = false,
                    },
                    maxLength = 25,
                    parameterHints = {
                        enable = true,
                    },
                    reborrowHints = {
                        enable = "never",
                    },
                    renderColons = true,
                    typeHints = {
                        enable = true,
                        hideClosureInitialization = false,
                        hideNamedConstructor = false,
                    },
                },
            },
        },
    },
}
