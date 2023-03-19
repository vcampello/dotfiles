-- TODO: consider merging the settings for lsp and treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "c",
        "lua",
        "rust",
        "javascript",
        "typescript",
        "html",
        "css",
        "help",
        "markdown",
        "yaml",
        "json",
        "vim",
    },
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    autotag = { enable = true },
    incremental_selection = { enable = true },
    -- Enable nvim-ts-context-commentstring
    context_commentstring = {
        enable = true,
    },
})
