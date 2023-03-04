require("rose-pine").setup({
    disabled_background = true
})
local palette = require("rose-pine.palette")

vim.cmd.colorscheme("rose-pine")

local is_transparent = false

function ToggleTransparent()
    if is_transparent then
        vim.api.nvim_set_hl(0, "Normal", { bg = palette.base })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = palette.surface })
        is_transparent = false
        return
    end

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    is_transparent = true
end

ToggleTransparent()

vim.keymap.set("n", "<leader>tt", ToggleTransparent)
vim.keymap.set("n", "<leader>td", function() vim.o.background = 'dark' end)
vim.keymap.set("n", "<leader>tl", function() vim.o.background = 'light' end)
