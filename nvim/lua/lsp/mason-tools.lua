return {
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
    },
  },
}
