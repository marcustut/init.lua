local telescope = require("telescope")
local telescope_tabs = require("telescope-tabs")

telescope.setup({
	["ui-select"] = { require("telescope.themes").get_dropdown() },
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = "move_selection_next",
				["<C-k>"] = "move_selection_previous",
			},
		},
	},
	extensions = {
		file_browser = {
			theme = "ivy",
			hijack_netrw = true,
		},
	},
})
telescope.load_extension("live_grep_args")
telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("telescope-tabs")
telescope.load_extension("project")
telescope.load_extension("file_browser")
telescope_tabs.setup()

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>ft", telescope_tabs.list_tabs, { desc = "[F]ind [T]abs" })
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
vim.keymap.set("n", "<leader>op", telescope.extensions.file_browser.file_browser, { desc = "[O]pen [P]roject Browser" })
vim.keymap.set("n", "<leader>fp", telescope.extensions.project.project, { desc = "[F]ind [P]rojects" })
vim.keymap.set("n", "<leader>fw", builtin.live_grep, { desc = "[F]ind [W]ords (live grep)" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
vim.keymap.set("n", "<leader>:", "<cmd>Telescope cmdline<cr>", { desc = "[F]ind commands" })

-- Slightly advanced example of overriding default behavior and theme
vim.keymap.set("n", "<leader>/", function()
	-- You can pass additional configuration to Telescope to change the theme, layout, etc.
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

-- It's also possible to pass additional configuration options.
--  See `:help telescope.builtin.live_grep()` for information about particular keys
vim.keymap.set("n", "<leader>f/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[F]ind [/] in Open Files" })

-- Shortcut for searching your Neovim configuration files
vim.keymap.set("n", "<leader>fn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[F]ind [N]eovim files" })
