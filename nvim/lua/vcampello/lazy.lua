-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.keymap.set("n", "<leader>ll", vim.cmd.Lazy, { noremap = true, silent = true, desc = "Open Lazy" })
require("lazy").setup({

    -- Themes
    { "Shatur/neovim-ayu", lazy = false },
    { "catppuccin/nvim", name = "catppuccin", lazy = false },
    --
    -- Tools
    -- use('nvim-treesitter/playground')
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    "stevearc/dressing.nvim",
    "tpope/vim-fugitive",
    "mbbill/undotree",
    "lewis6991/gitsigns.nvim",
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            "s1n7ax/nvim-window-picker",
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "kyazdani42/nvim-web-devicons" },
    },
    { "echasnovski/mini.nvim" },
    { "numToStr/Comment.nvim" }, -- mini.comment doesn't support block comments
    { "folke/which-key.nvim" },
    { "NvChad/nvim-colorizer.lua" },
    {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
    },

    {
        "akinsho/toggleterm.nvim",
    },
    { "dstein64/vim-startuptime" },
    {
        "sindrets/diffview.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            vim.keymap.set("n", "<leader>gd", vim.cmd.DiffviewOpen, { noremap = true, silent = true, desc = "Open Git Diffview" })
            vim.keymap.set("n", "<leader>gc", vim.cmd.DiffviewClose, { noremap = true, silent = true, desc = "Close Git Diffview" })
        end,
    },

    -- Syntax higlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter" },
    },
    -- LSP
    {
        "VonHeikemen/lsp-zero.nvim",
        dependencies = {
            -- LSP Support
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",

            -- Autocompletion
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",

            -- Snippets
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",

            -- Custom stuff
            "b0o/schemastore.nvim",
            "onsails/lspkind.nvim",
            "jose-elias-alvarez/null-ls.nvim",
            "JoosepAlviste/nvim-ts-context-commentstring",
            "simrat39/rust-tools.nvim",
        },
    },

    {
        "SmiteshP/nvim-navic",
        dependencies = { "neovim/nvim-lspconfig" },
    },
})
