return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- Use a sub-list to run only the first available formatter
      -- TODO: turn this into a table so it's not so repetitive
      javascript = { { "prettierd", "prettier" }, "eslint_d" },
      json = { "prettierd", "prettier" },
      markdown = { "prettierd", "prettier" },
      rust = { "rustfmt" },
      shell = { "shellcheck" },
    },
    format_on_save = {
      lsp_fallback = true,
      timeout_ms = 500,
    },
  },
  init = function()
    -- If you want the formatexpr, here is the place to set it
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
