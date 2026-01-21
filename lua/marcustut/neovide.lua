-- Font
vim.o.guifont = "IosevkaTerm Nerd Font:h14"

-- Transparency
vim.g.neovide_opacity = 0.8
vim.g.transparency = 0.8

-- Animation
vim.g.neovide_cursor_animation_length = 0.04

-- Scale
vim.g.neovide_scale_factor = 1.0
local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end
vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
end)
vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
end)

-- Clipboard
vim.api.nvim_set_keymap("v", "<D-c>", '"+y', { noremap = true })      -- Select line(s) in visual mode and copy (CTRL+Shift+V)
vim.api.nvim_set_keymap("i", "<D-v>", '<ESC>"+p', { noremap = true }) -- Paste in insert mode (CTRL+Shift+C)
vim.api.nvim_set_keymap("n", "<D-v>", '"+p', { noremap = true })      -- Paste in normal mode (CTRL+Shift+C)
