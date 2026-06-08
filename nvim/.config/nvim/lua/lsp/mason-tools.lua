return {
    lazy = false,
    -- Tool installer for mason
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
        ensure_installed = {
            "bash-language-server",
            "shfmt",
            "gopls",
            "shellcheck",
            "eslint_d",
            "prettierd",
            "golangci-lint-langserver",
            -- "circleci-yaml-language-server",
            "biome",
            "ruff",
        },
    },
}
