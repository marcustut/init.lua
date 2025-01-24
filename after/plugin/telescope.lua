local telescope = require('telescope')

telescope.setup()
telescope.load_extension('live_grep_args')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fp', builtin.git_files, {})
vim.keymap.set('n', '<leader>fw', telescope.extensions.live_grep_args.live_grep_args, {})
vim.keymap.set('n', '<leader>f:', '<cmd>Telescope cmdline<cr>')
