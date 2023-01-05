-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- Themes
    use('Shatur/neovim-ayu')
    use('EdenEast/nightfox.nvim')
    use("olimorris/onedarkpro.nvim")
    -- Tools
    use('nvim-treesitter/playground')
    use('tpope/vim-fugitive')
    use('mbbill/undotree')
    use('mhinz/vim-signify')
    use {
        'nvim-tree/nvim-tree.lua',
        as = 'nvim-tree',
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use('nanozuki/tabby.nvim')

    -- Syntax higlighting
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    -- LSP
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    use {
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig"
    }
end)
