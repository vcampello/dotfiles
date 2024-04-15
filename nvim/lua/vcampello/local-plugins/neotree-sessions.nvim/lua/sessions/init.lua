--This file should have all functions that are in the public api and either set
--or read the state of this source.

local vim = vim
local renderer = require("neo-tree.ui.renderer")
local manager = require("neo-tree.sources.manager")
local events = require("neo-tree.events")
local p_query = require("possession.query")

local M = {
  -- This is the name our source will be referred to as
  -- within Neo-tree
  name = "sessions",
  -- This is how our source will be displayed in the Source Selector
  display_name = "󱗖 Sessions",
}

---Navigate to the given path.
---@param path string Path to navigate to. If empty, will navigate to the cwd.
M.navigate = function(state, path)
  if path == nil then
    path = vim.fn.getcwd()
  end
  state.path = path

  -- to group with ease
  local group_map = {}
  -- to display
  local group_nodes = {}

  local home_dir = os.getenv("HOME")
  for _, value in ipairs(p_query.as_list()) do
    if not group_map[value.cwd] then
      local group = {
        id = value.cwd,
        type = "directory",
        name = value.cwd:gsub(home_dir, "~"),
        path = value.file,
        children = {},
      }
      table.insert(group_nodes, group)
      group_map[value.cwd] = group
    end

    table.insert(group_map[value.cwd].children, {
      id = value.file,
      name = value.name,
      type = "file",
      path = value.file,
    })
  end
  renderer.show_nodes(group_nodes, state)
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
M.setup = function(config, global_config)
  if config.use_libuv_file_watcher then
    manager.subscribe(M.name, {
      event = events.FS_EVENT,
      handler = function(args)
        manager.refresh(M.name)
      end,
    })
  end
end

return M
