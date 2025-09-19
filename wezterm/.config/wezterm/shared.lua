local theme = require("theme")

local M = {}

---Build a formatted string composed of all the array elements.
---@param components string[]
---@return string
function M.format_text(components)
  local non_empty = {}

  -- only use string values with length > 0
  for _, value in ipairs(components) do
    if value and type(value) == "string" and #value > 0 then
      table.insert(non_empty, value)
    end
  end

  local text = " " .. table.concat(non_empty, " ") .. " "

  -- ignore if it's only whitespace
  if #text:gsub("%s+", "") == 0 then
    return ""
  end

  return text
end

---@alias SeparatorPosition 'left'|'right'

---Separators for status/tab components
M.separator = {
  left = "",
  right = "",
}

---Insert gap into wezterm text component See: "https://wezfurlong.org/wezterm/config/lua/wezterm/format.html?h=format" @param components table
---@param opts { position: SeparatorPosition, bg: string, fg: string }
function M.insert_gap(components, opts)
  table.insert(components, { Foreground = { Color = opts.fg } })
  table.insert(components, { Background = { Color = opts.bg } })
  table.insert(components, { Text = M.separator[opts.position] })
end

---Build status bar for wezterm
---@param components string[][]
---@param opts { bg: string, fg: string, italic?: boolean }
function M.build_elements(components, opts)
  local elements = {}

  table.insert(elements, { Attribute = { Italic = opts.italic or false } })

  for _, component in ipairs(components) do
    M.insert_gap(elements, { position = "left", bg = theme.palette.status_bar.bg, fg = opts.bg })
    table.insert(elements, { Foreground = { Color = opts.fg } })
    table.insert(elements, { Background = { Color = opts.bg } })
    table.insert(elements, { Text = M.format_text(component) })
    M.insert_gap(elements, { position = "right", bg = opts.bg, fg = theme.palette.status_bar.bg })
    table.insert(elements, "ResetAttributes")
  end

  return elements
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

return M
