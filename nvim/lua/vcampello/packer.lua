-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

return require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")

    -- Themes
    use({ "Shatur/neovim-ayu" })
    use({ "catppuccin/nvim", as = "catppuccin" })
    --
    -- Tools
    -- use('nvim-treesitter/playground')
    use({
        "nvim-telescope/telescope.nvim",
        tag = "0.1.0",
        requires = { { "nvim-lua/plenary.nvim" } },
    })
    use({ "tpope/vim-fugitive" })
    use({ "mbbill/undotree" })
    use({ "lewis6991/gitsigns.nvim" })
    use({
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            {
                "s1n7ax/nvim-window-picker",
                tag = "v1.*",
            },
        },
    })
    use({
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
    })
    use({ "echasnovski/mini.nvim" })
    use({ "numToStr/Comment.nvim" }) -- mini.comment doesn't support block comments
    use({ "folke/which-key.nvim" })
    use({ "NvChad/nvim-colorizer.lua" })

    use({
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
    })

    use({
        "akinsho/toggleterm.nvim",
        tag = "*",
    })
    use({ "dstein64/vim-startuptime" })

    -- Syntax higlighting
    use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
    use({
        "windwp/nvim-ts-autotag",
        after = "nvim-treesitter",
    })
    -- LSP
    use({
        "VonHeikemen/lsp-zero.nvim",
        requires = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "saadparwaiz1/cmp_luasnip" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },

            -- Snippets
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },

            -- Custom stuff
            { "b0o/schemastore.nvim" },
            { "onsails/lspkind.nvim" },
            { "jose-elias-alvarez/null-ls.nvim" },
            { "JoosepAlviste/nvim-ts-context-commentstring" },
        },
    })

    use({
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig",
    })
    use({ "simrat39/rust-tools.nvim" })
end)
