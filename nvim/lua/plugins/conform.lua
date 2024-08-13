local prettier = require("lib.prettier")

-- disable format on save
vim.api.nvim_create_user_command("FormatDisable", function()
  vim.b.disable_autoformat = true
end, {
  desc = "Disable autoformat-on-save for buffer",
})

-- enable format on save
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save for buffer",
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

return {
  "stevearc/conform.nvim",
  opts = {
    log_level = vim.log.levels.DEBUG,
    formatters = {
      prettierd = {
        env = function()
          -- Should be a function so it executes with the correct context
          local config = prettier.get_config_for_filetype(vim.bo.filetype)
          -- print("default formatter rc: " .. config)
          return {
            PRETTIERD_DEFAULT_CONFIG = config,
          }
        end,
      },
    },
    formatters_by_ft = vim.tbl_deep_extend(
      "force",
      {
        lua = { "stylua" },
        python = { "isort", "black" },
        rust = { "rustfmt" },
        shell = { "shellcheck" },
        templ = { "templ" },
      },
      use_prettier({
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "markdown",
        "typescript",
        "typescriptreact",
        "yaml",
      })
    ),
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.b[bufnr].disable_autoformat then
        vim.g.disable_autoformat = false
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
