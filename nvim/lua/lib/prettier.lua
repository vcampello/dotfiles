local M = {}

local conf_path = vim.fn.stdpath("config")

---List of prettier configurations
M.rc_store = {
  default = tostring(vim.fn.expand(conf_path .. "/other-configs/prettierrc-default.json")),
  short_indent = tostring(vim.fn.expand(conf_path .. "/other-configs/prettierrc-short-indent.json")),
}

---Validate known prettier configurations
M.validate_config_store = function()
  vim.notify("Validating prettierrc config store...", vim.log.levels.INFO)

  for key, value in pairs(M.rc_store) do
    local status = vim.fn.filereadable(value) and "valid" or "invalid"
    vim.notify(string.format("- [%s] %s: %s", status, key, value), vim.log.levels.INFO)
  end
end

---prettierrc by filetype
M.config_by_ft = {
  html = M.rc_store.short_indent,
  json = M.rc_store.short_indent,
  jsonc = M.rc_store.short_indent,
  yaml = M.rc_store.short_indent,
}

---Find matching prettierc or return the default
---@param ft string filetype
---@return string filepath
M.get_config_for_filetype = function(ft)
  local specifc_config = M.config_by_ft[ft]
  if specifc_config then
    return specifc_config
  end

  return M.rc_store.default
end

return M
