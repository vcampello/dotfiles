local format_utils = require("lib.format_utils")

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

---Configure multiple language with the same formatter
---@param formatters conform.FiletypeFormatter
---@param langs string[]
---@return table
local function use_formatter_for(formatters, langs)
  if langs == nil then
    langs = {}
  end

  local mapped = {}

  for _, value in ipairs(langs) do
    mapped[value] = formatters
  end

  return mapped
end

return {
  "stevearc/conform.nvim",
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    log_level = vim.log.levels.DEBUG,
    formatters = {
      prettierd = {
        -- Should be a function so it executes with the correct context
        env = function()
          return {
            PRETTIERD_DEFAULT_CONFIG = format_utils.store.prettier,
          }
        end,
      },
      biome = {
        -- Should be a function so it executes with the correct context
        env = function()
          -- NOTE: setting BIOME_CONFIG_PATH causes errors if the project has a biome config
          if format_utils.has_biome_config() then
            return {}
          end

          return {
            BIOME_CONFIG_PATH = format_utils.store.biome,
          }
        end,
      },
    },
    formatters_by_ft = vim.tbl_deep_extend(
      "force",
      {
        lua = { "stylua" },
        python = { "isort", "black", stop_after_first = true },
        rust = { "rustfmt" },
        shell = { "shellcheck" },
      },
      -- core prettier languages
      use_formatter_for({ "prettierd", "prettier", stop_after_first = true }, {
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
        "vue",
      }),
      -- override prettier config with biome when prettier is missing
      format_utils.has_prettier_config() and {}
        or use_formatter_for({ "biome", "biome-organize-imports", stop_after_first = false }, {
          "graphql",
          "html",
          "javascript",
          "javascriptreact",
          "json",
          "jsonc",
          "typescript",
          "typescriptreact",
          "vue",
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
