require("nvim-treesitter.configs").setup({
    -- A list of parser names, or "all"
    ensure_installed = { "c", "lua", "rust", "javascript", "typescript", "html", "css", "c", "cpp", "help", "python" },
    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,
    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    autotag = { enable = true },
    incremental_selection = { enable = true },
})
