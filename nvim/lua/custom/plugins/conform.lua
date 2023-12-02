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

local other_configs = {
  ["*"] = { "codespell" },
  lua = { "stylua" },
  python = { "isort", "black" },
  rust = { "rustfmt" },
  shell = { "shellcheck" },
}

local PRETTIER = {}

PRETTIER.rc_store = {
  default = tostring(vim.fn.expand("~/.config/nvim/other-configs/prettierrc-default.json")),
  short_indent = tostring(vim.fn.expand("~/.config/nvim/other-configs/prettierrc-configs.json")),
}

PRETTIER.validate_config_store = function()
  print("# Validating prettierrc config store...")

  for key, value in pairs(PRETTIER.rc_store) do
    local status = vim.fn.filereadable(value) and "valid" or "invalid"
    print(string.format("- [%s] %s: %s", status, key, value))
  end
end

PRETTIER.filetypes = {
  html = PRETTIER.rc_store.short_indent,
  json = PRETTIER.rc_store.short_indent,
  jsonc = PRETTIER.rc_store.short_indent,
  yaml = PRETTIER.rc_store.short_indent,
}

---Find matching prettierc
---@param ft string filetype
---@return string filepath
PRETTIER.get_config_for_filetype = function(ft)
  local specifc_config = PRETTIER.filetypes[ft]
  if specifc_config then
    return specifc_config
  end

  return PRETTIER.rc_store.default
end

-- Validate config
-- PRETTIER.validate_config_store()

return {
  "stevearc/conform.nvim",
  opts = {
    -- log_level = vim.log.levels.DEBUG,
    formatters = {
      prettierd = {
        env = function()
          -- Should be a function so it executes with the correct context
          local config = PRETTIER.get_config_for_filetype(vim.bo.filetype)
          print("default formatter rc: " .. config)
          return {
            PRETTIERD_DEFAULT_CONFIG = config,
          }
        end,
      },
    },
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
