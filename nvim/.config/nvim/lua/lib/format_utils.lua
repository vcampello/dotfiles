local M = {}
M.prettier = {}

local conf_path = vim.fn.stdpath("config")

---List of prettier configurations
M.store = {
  prettier = tostring(vim.fn.expand(conf_path .. "/other-configs/prettierrc.json")),
  biome = tostring(vim.fn.expand(conf_path .. "/other-configs/biome.jsonc")),
}

---Validate known prettier configurations
function M.validate_config_store()
  vim.notify("Validating formatter config store...", vim.log.levels.INFO)

  for key, value in pairs(M.store) do
    local status = vim.fn.filereadable(value) and "valid" or "invalid"
    vim.notify(string.format("- [%s] %s: %s", status, key, value), vim.log.levels.INFO)
  end
end

---Find matching prettierc or return the default
---@param ft string filetype
---@return string filepath
function M.prettier.get_config_for_filetype(ft)
  local specifc_config = M.prettier.config_by_ft[ft]
  if specifc_config then
    return specifc_config
  end

  return M.store.prettier
end

---Check if project root has a prettier config
---@return boolean
function M.has_prettier_config()
  return #vim.fn.glob(".prettierrc*") > 0
end

---Check if project root has a biome config
---@return boolean
function M.has_biome_config()
  return #vim.fn.glob("biome.{json,jsonc}") > 0
end

return M
