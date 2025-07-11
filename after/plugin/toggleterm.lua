vim.keymap.set("n", "<leader>ot", function()
	vim.cmd([[ToggleTerm size=20]])
end, { desc = "[O]pen [T]erminal" })

vim.keymap.set("n", "<leader>oT", function()
	vim.cmd([[ToggleTerm direction=vertical size=100]])
end, { desc = "[O]pen [T]erminal (Vertical)" })

vim.keymap.set("n", "<leader>of", function()
	vim.cmd([[ToggleTerm direction=float]])
end, { desc = "[O]pen [T]erminal [F]loating" })
