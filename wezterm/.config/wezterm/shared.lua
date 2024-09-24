local theme = require("theme")

local M = {}

---Build a formatted string composed of all the array elements.
---@param components string[]
---@return string
function M.format_text(components)
  local text = " " .. table.concat(components, " ") .. " "

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

---Insert gap into wezterm text component
---See: "https://wezfurlong.org/wezterm/config/lua/wezterm/format.html?h=format"
---@param components table
---@param opts { position: SeparatorPosition, bg: string, fg: string }
function M.insert_gap(components, opts)
  table.insert(components, { Foreground = { Color = opts.fg } })
  table.insert(components, { Background = { Color = opts.bg } })
  table.insert(components, { Text = M.separator[opts.position] })
end

---Build status bar for wezterm
---@param components string[]
---@param opts { bg: string, fg: string }
function M.build_elements(components, opts)
  local elements = {}

  table.insert(elements, { Attribute = { Italic = true } })

  for _, text in ipairs(components) do
    M.insert_gap(elements, { position = "left", bg = theme.palette.status_bar.bg, fg = opts.bg })
    table.insert(elements, { Foreground = { Color = opts.fg } })
    table.insert(elements, { Background = { Color = opts.bg } })
    table.insert(elements, { Text = text })
    M.insert_gap(elements, { position = "right", bg = opts.bg, fg = theme.palette.status_bar.bg })
    table.insert(elements, "ResetAttributes")
  end

  return elements
end

---Concatenate array
---@param target any[]
---@param other any[]
function M.concat_array(target, other)
  for _, v in ipairs(other) do
    table.insert(target, v)
  end
end

return M
