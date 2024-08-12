local M = {}

--Get table keys
---@param source table{number: any}
---@return (string | number)[]
M.tableKeys = function(source)
  local keys = {}
  for key in pairs(source) do
    table.insert(keys, key)
  end
  return keys
end

return M
