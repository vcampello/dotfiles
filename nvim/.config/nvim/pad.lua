local q = require("possession.query")

local M = {
  -- This is the name our source will be referred to as
  -- within Neo-tree
  name = "sessions_source",
  -- This is how our source will be displayed in the Source Selector
  display_name = "sessions source",
}
-- print(vim.inspect(q.as_list()))
local home_dir = os.getenv("HOME")

local titles = {}

for index, value in ipairs(q.as_list()) do
  print(value.name)

  table.insert(titles, {
    cwd = value.cwd,
    name = value.name,
    root = value.cwd:gsub(home_dir, "~"),
  })
end

print(vim.inspect(titles))
