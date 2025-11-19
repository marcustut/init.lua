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
