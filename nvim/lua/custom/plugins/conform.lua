-- disable format on save
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

-- enable format on save
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

local function use_prettier(langs)
  if langs == nil then
    langs = {}
  end

  local mapped = {}

  for _, value in ipairs(langs) do
    -- Use a sub-list to run only the first available formatter
    mapped[value] = { { "prettierd", "prettier" } }
  end

  return mapped
end

local shared_prettier_configs = use_prettier({
  "typescript",
  "javascript",
  "json",
  "jasonc",
  "markdown",
  "graphql",
})

local other_configs = {
  lua = { "stylua" },
  python = { "isort", "black" },
  rust = { "rustfmt" },
  shell = { "shellcheck" },
  ["*"] = { "codespell" },
}

return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = vim.tbl_deep_extend("force", {}, shared_prettier_configs, other_configs),
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    init = function()
      -- If you want the formatexpr, here is the place to set it
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
