return {
  lazy = false,
  -- Tool installer for mason
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  opts = {
    ensure_installed = {
      "bash-language-server",
      "shfmt",
      "gopls",
      "gotests",
      "shellcheck",
      "eslint_d",
      "prettierd",
      "stylua",
      "nixpkgs-fmt",
      "vue-language-server",
      "golangci-lint-langserver",
    },
  },
}
