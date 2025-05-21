require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    rust = { "rustfmt", lsp_format = "fallback" },
    nix = { "nixfmt" },
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
