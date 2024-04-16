--This file should have all functions that are in the public api and either set
--or read the state of this source.

local vim = vim
local renderer = require("neo-tree.ui.renderer")
local manager = require("neo-tree.sources.manager")
local utils = require("neo-tree.utils")
local p_query = require("possession.query")

local M = {
  -- This is the name our source will be referred to as
  -- within Neo-tree
  name = "sessions",
  -- This is how our source will be displayed in the Source Selector
  display_name = "󱗖 Sessions",
}

local wrap = function(func)
  return utils.wrap(func, M.name)
end

M.get_state = function()
  return manager.get_state(M.name)
end

---Navigate to the given path.
---@param path string Path to navigate to. If empty, will navigate to the cwd.
M.navigate = function(state, path)
  if path == nil then
    path = vim.fn.getcwd()
  end
  state.path = path

  local nodes = {}
  local cwd = vim.uv.cwd()

  local sessions = p_query.as_list()
  p_query.sort_by(sessions, "name", false)

  for _, value in ipairs(sessions) do
    if value.cwd == cwd then
      table.insert(nodes, {
        id = value.file,
        name = value.name,
        -- FIXME: how to change this? It returns file stats as it is
        type = "file",
        path = value.file,
        children = {},
        extra = {},
      })
    end
  end
  renderer.show_nodes(nodes, state)
end

M.default_config = {
  window = {
    mappings = {
      ["d"] = "delete",
      ["u"] = "update",
      ["<cr>"] = "load",
      ["r"] = "rename",
    },
  },
}

--Placeholder
M.config = function(opts)
  opts = opts or {}
end

---Configures the plugin, should be called before the plugin is used.
---@param config table Configuration table containing any keys that the user
--wants to change from the defaults. May be empty to accept default values.
M.setup = function(config, global_config) end

return M
