---@class Config
---Contains global custom configs from yours truly
---@field auto_format boolean
local M = {}

---Default settings
---@return Config
function M.new()
    setmetatable(M, { __index = M })
    ---@type Config
    local o = {}

    o.auto_format = true

    return o
end

_G.Config = M.new()
