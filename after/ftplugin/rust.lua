local bufnr = vim.api.nvim_get_current_buf()

-- Helper function to map keybinds
local map = function(keys, func, desc, mode)
    mode = mode or 'n'
    vim.keymap.set(mode, keys, func, { silent = true, buffer = bufnr, desc = 'LSP: ' .. desc })
end

map("<leader>lc", function() vim.cmd.RustLsp("flyCheck") end, 'Cargo [C]heck')
map("<leader>le", function() vim.cmd.RustLsp("expandMacro") end, '[E]xpand Macros')
map("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, 'Hover')
map("<leader>lws", function() vim.cmd.RustLsp("workspaceSymbol") end, '[W]orkspace [S]ymbols')
map("<leader>lj", function() vim.cmd.RustLsp({ "explainError", "cycle" }) end, 'Next Diagnostic')
map("<leader>lk", function() vim.cmd.RustLsp({ "explainError", "cycle_prev" }) end, 'Previous Diagnostic')
map("<leader>la", function() vim.cmd.RustLsp("codeAction") end, 'Code [A]ction')
