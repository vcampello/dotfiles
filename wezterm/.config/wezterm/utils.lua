local M = {}

---@enum target
M.TARGET = {
  darwin_aarchx64 = "aarch64-apple-darwin",
  darwin_x86_64 = "x86_64-apple-darwin",
  linux_x86_64 = "x86_64-unknown-linux-gnu",
  win_x86_64 = "x86_64-pc-windows-msvc",
}

---Check wezterm macos target triple
---@param target any
---@return boolean
function M.is_macos(target)
  return target == M.TARGET.darwin_aarchx64 or target == M.TARGET.darwin_x86_64
end

---Check wezterm linux target triple
---@param target any
---@return boolean
function M.is_linux(target)
  return target == M.TARGET.linux_x86_64
end

---Check wezterm windows target triple
---@param target any
---@return boolean
function M.is_windows(target)
  return target == M.TARGET.win_x86_64
end

---Concatenate array
---@param ... any[] other tables to be merged
---@return table out single table with all elements
function M.concat_array(...)
  local args = { ... }
  local out = {}

  for _, tbl in ipairs(args) do
    for _, v in ipairs(tbl) do
      table.insert(out, v)
    end
  end
  return out
end

---Concatenate array
---@param list any[]
---@param ... any other tables to be merged
function M.insert_many(list, ...)
  local args = { ... }

  for _, v in ipairs(args) do
    table.insert(list, v)
  end
end

return M
