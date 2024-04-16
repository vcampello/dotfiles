--This file should contain all commands meant to be used by mappings.
local vim = vim
local cc = require("neo-tree.sources.common.commands")
local manager = require("neo-tree.sources.manager")
local log = require("neo-tree.log")
local inputs = require("neo-tree.ui.inputs")
local p_sessions = require("possession.session")
local p_query = require("possession.query")

local M = {
  name = "sessions",
}

M.refresh = function(state)
  manager.refresh(M.name, state)
end

M.delete = function(state)
  local node = state.tree:get_node()

  inputs.confirm("Delete session?", function(yes)
    if yes then
      p_sessions.delete(node.name, { no_confirm = true })
      M.refresh(state)
    end
  end)
end

M.update = function(state)
  local node = state.tree:get_node()

  inputs.confirm("Update selected session?", function(yes)
    if yes then
      p_sessions.save(node.name, { no_confirm = true })
    end
  end)
end

M.add = function(state)
  local node = state.tree:get_node()
  if node.type ~= "file" then
    log.warn("Node is not a file: " .. node.name)
    return
  end

  inputs.input("Enter a name for the new session", "", function(new_name)
    if not new_name or new_name == "" then
      log.info("Operation canceled")
      return
    end

    p_sessions.save(new_name, { no_confirm = true })
  end)
end

M.load = function(state)
  local node = state.tree:get_node()

  p_sessions.load(node.name)

  -- inputs.confirm("Load session?", function(yes)
  --   if yes thenequire"cmp.utils.feedkeys".run(186)
  --
  --     p_sessions.load(node.name)
  --   end
  -- end)
end

M.show_debug_info = function(state)
  print(vim.inspect(state))
end

M.rename = function(state)
  local node = state.tree:get_node()
  local old_name = node.name
  local msg = string.format('Enter a new name for "%s":', old_name)

  inputs.input(msg, old_name, function(new_name)
    if not new_name or new_name == "" then
      log.info("Operation canceled")
      return
    end

    p_sessions.rename(node.name, new_name)
    M.refresh()
  end)
end

cc._add_common_commands(M)

return M
