local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost packer.lua source <afile> | PackerSync
  augroup end
]])

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use({
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        requires = { { 'nvim-lua/plenary.nvim' } }
    })

    -- theme
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })

    -- syntax highlighting
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use("nvim-treesitter/nvim-treesitter-context")

    -- git stuff
    use('tpope/vim-fugitive')
    use('lewis6991/gitsigns.nvim')

    -- lsp
    use({
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            { 'williamboman/mason.nvim' }, -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'hrsh7th/cmp-buffer' }, -- Optional
            { 'hrsh7th/cmp-path' }, -- Optional
            { 'saadparwaiz1/cmp_luasnip' }, -- Optional
            { 'hrsh7th/cmp-nvim-lua' }, -- Optional

            -- Snippets
            { 'L3MON4D3/LuaSnip' }, -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
        }
    })

    -- search and replace
    use({
        'windwp/nvim-spectre',
        requires = { "nvim-lua/plenary.nvim" }
    })

    -- file browser
    use({
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    })
    use('nvim-tree/nvim-web-devicons')

    -- ai
    use("github/copilot.vim")

    -- focus
    use("folke/zen-mode.nvim")
    use('theprimeagen/harpoon')
    use('mbbill/undotree')

    -- text editing
    use("tpope/vim-surround")
    use("tpope/vim-commentary")
    use({
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require('packer').sync()
    end
end)
