---@class Config
---Contains global custom configs from yours truly
---@field auto_format boolean
local M = {}

---Default settings
---@return Config
function M.defaults()
    ---@type Config
    local o = {}

    o.auto_format = true

    return o
end

_G.Config = M.defaults()
