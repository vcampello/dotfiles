local renderer = require("neo-tree.ui.renderer")
local manager = require("neo-tree.sources.manager")
local events = require("neo-tree.events")
local utils = require("neo-tree.utils")

local M = {
  name = "sessions",
  display_name = "Sessions",
}

function M.setup()
  print("it works!")
end

---Configures the plugin, should be called before the plugin is used.
---@param config table Configuration table containing any keys that the user
--wants to change from the defaults. May be empty to accept default values.
M.setup = function(config, global_config)
  print("running config")
  -- redister or custom stat provider to override the default libuv one
  require("neo-tree.utils").register_stat_provider("sessions", M.get_node_stat)
  -- You most likely want to use this function to subscribe to events
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
