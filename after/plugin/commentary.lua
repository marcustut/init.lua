vim.keymap.set("n", "<leader>cc", ":Commentary<CR>")
vim.keymap.set("v", "<leader>c", ":Commentary<CR>")

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescriptreact", "javascriptreact" },
    callback = function()
        vim.bo.commentstring = "{/* %s */}"
    end,
})
