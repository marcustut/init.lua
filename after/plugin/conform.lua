require("conform").setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
            return nil
        else
            return {
                timeout_ms = 500,
                lsp_format = "fallback",
            }
        end
    end,
    formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "biome" },
        typescript = { "biome" },
        javascriptreact = { "biome" },
        typescriptreact = { "biome" },
        nix = { "nixfmt" },
        bash = { 'shfmt', 'shellcheck' },
        zsh = { 'shfmt', 'shellcheck' },
        sh = { 'shfmt', 'shellcheck' },
    },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
