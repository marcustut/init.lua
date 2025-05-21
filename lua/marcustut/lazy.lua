-- Install lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'jonarrien/telescope-cmdline.nvim',
            { 'nvim-telescope/telescope-live-grep-args.nvim', version = "^1.0.0" }
        },
    },

    -- File manager
    { 'nvim-tree/nvim-tree.lua' },

    -- UI
    { 'VonHeikemen/searchbox.nvim', dependencies = { 'MunifTanjim/nui.nvim' } },

    -- Status line
    {
        'linrongbin16/lsp-progress.nvim',
        config = function()
            require('lsp-progress').setup()
            -- listen lsp-progress event and refresh lualine
            vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
            vim.api.nvim_create_autocmd("User", {
                group = "lualine_augroup",
                pattern = "LspProgressStatusUpdated",
                callback = require("lualine").refresh,
            })
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'linrongbin16/lsp-progress.nvim' },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = { { 'filename', path = 1, }, function() return require('lsp-progress').progress() end },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            }
        end
    },

    -- Copilot
    {
        "github/copilot.vim",
        tags = "v1.41.0",
        event = "InsertEnter"
    },

    -- Terminal
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = true
    },

    -- SSH
    {
        "amitds1997/remote-nvim.nvim",
        version = "*",                       -- Pin to GitHub releases
        dependencies = {
            "nvim-lua/plenary.nvim",         -- For standard functions
            "MunifTanjim/nui.nvim",          -- To build the plugin UI
            "nvim-telescope/telescope.nvim", -- For picking b/w different remote methods
        },
        config = true,
    },

    -- Colorschemes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
    },
    {
        "rebelot/kanagawa.nvim",
        priority = 1000,
    },
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
    },
    {
        "xiyaowong/transparent.nvim",
        priority = 1000,
    },

    -- Icons
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true
    },

    -- Git
    "tpope/vim-fugitive",
    {
        "lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup() end,
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        version = false, -- last release is way too old and doesn't work on Windows
        build = ':TSUpdate',
        event = { 'VeryLazy' },
        cmd = { 'TSUpdateSync', 'TSUpdate', 'TSInstall' },
        config = function()
            require('nvim-treesitter.configs').setup({
                highlight = { enable = true },
                indent = { enable = true },
                autotag = { enable = true },
                ensure_installed = {
                    "bash",
                    "c",
                    "rust",
                    "diff",
                    "html",
                    "javascript",
                    "jsdoc",
                    "json",
                    "jsonc",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "regex",
                    "toml",
                    "tsx",
                    "typescript",
                    "yaml",
                    "vimdoc",
                },
            })
        end
    },

    -- Language Server Protocol (LSP)
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x'
    },
    { 'neovim/nvim-lspconfig' },
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'stevearc/conform.nvim' },

    -- Debugging
    { 'mfussenegger/nvim-dap' },

    -- Inlay hints
    {
        'MysticalDevil/inlay-hints.nvim',
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        config = function() require("inlay-hints").setup() end,
    },

    -- Autocompletion
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-path' },
    { 'saadparwaiz1/cmp_luasnip' },
    { 'hrsh7th/cmp-nvim-lua' },

    -- Snippets
    { 'L3MON4D3/LuaSnip' },
    { 'rafamadriz/friendly-snippets' },

    -- Rust
    {
        'mrcjkb/rustaceanvim',
        ft = "rust",
        version = '^4',
        lazy = false
    },
    {
        "saecki/crates.nvim",
        ft = "toml",
        tag = "v0.4.0",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function() require("crates").setup() end,
    },

    -- Typst
    {
        'kaarmu/typst.vim',
        ft = 'typst',
        lazy = false,
    },

    -- Rescript
    {
        'nkrkv/nvim-treesitter-rescript',
        ft = 'rescript',
    },

    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
        opts = {},
    },

    -- Utilities
    "tpope/vim-surround",
    "tpope/vim-commentary",
    "mg979/vim-visual-multi",
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("nvim-autopairs").setup() end,
    },
})
