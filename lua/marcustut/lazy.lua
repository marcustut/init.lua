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
        "nvim-telescope/telescope.nvim",
        tag = '0.1.5',
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
    },

    -- Copilot
    {
        "github/copilot.vim",
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
        version = "*",                  -- Pin to GitHub releases
        dependencies = {
            "nvim-lua/plenary.nvim",    -- For standard functions
            "MunifTanjim/nui.nvim",     -- To build the plugin UI
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
        "simrat39/rust-tools.nvim",
        ft = "rust",
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
