---@class ConfigEntry
---@field enable_otter boolean Enable other embedded lsp
---@field ignore boolean Do not run autocommand
---@field maps_to string Convert filetype to another parser name - e.g. typescriptreact -> tsx
---@field installed boolean Prevent reprocessing and infinite calls when sending notifications inside of the autocmd

local M = {}
---@type ConfigEntry[]
M.configs = {}

---@param ft string
---@param entry? ConfigEntry
---@return ConfigEntry
function M:update(ft, entry)
  local opts = entry or {}

  ---@type ConfigEntry
  local defaults = {
    enable_otter = false,
    ignore = false,
    -- install either the override or the lang itself
    maps_to = opts.maps_to or ft,
    installed = false,
  }

  local new_config = vim.tbl_extend("force", M.configs[ft] or defaults, opts)
  self.configs[ft] = new_config

  return new_config
end

-- overrides
M:update("javascriptreact", { maps_to = "jsx" })
M:update("typescriptreact", { maps_to = "tsx" })
M:update("toml", { enable_otter = true })
M:update("mermaid") -- embedded into markdown

return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  build = ":TSUpdate",
  dependencies = {
    "jmbuhr/otter.nvim",
  },
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*",
      callback = function(ev)
        local ft = ev.match
        local bufnr = ev.buf
        local config = M:update(ft)

        if config.ignore then
          return
        end

        -- it cannot be auto installed
        if not config.installed and require("nvim-treesitter.parsers")[config.maps_to] == nil then
          M:update(ft, { ignore = true, installed = true })
          return
        end

        -- all good
        if config.installed then
          vim.treesitter.start(bufnr, config.maps_to)
          if config.enable_otter then
            require("otter").activate()
          end
        end

        -- try to install it without blocking and prevent reprocessing
        -- otter will only be enabled in the next run
        vim.schedule(function()
          require("nvim-treesitter").install(config.maps_to):wait()
          M:update(ft, { ignore = false, installed = true })

          -- enable on original buffer
          vim.treesitter.start(bufnr, config.maps_to)
        end)
      end,
    })
  end,
}
