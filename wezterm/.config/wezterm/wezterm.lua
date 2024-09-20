-- Pull in the wezterm API
local wezterm = require("wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")

-- This table will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = "Bright Lights"
-- config.color_scheme = "Dark+"
config.color_scheme = "carbonfox"
-- config.font = wezterm.font_with_fallback({
--   -- { family = "Victor Mono", weight = "DemiBold" },
--   { family = "JetBrainsMono Nerd Font", weight = "Regular" },
--   { family = "Symbols Nerd Font Mono" },
-- })

-- Disable as the pop-up comes up way too often
config.warn_about_missing_glyphs = false

-- fix strike through position
-- might not work at all until this is set -> https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines
config.strikethrough_position = "0.6cell"

if wezterm.target_triple == "aarch64-apple-darwin" or wezterm.target_triple == "x86_64-apple-darwin" then
  -- macOS detected
  config.font_size = 14
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
  -- linux detected
  config.font_size = 10.5
  -- config.window_decorations = "RESIZE"
elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
  -- windows detected
  config.font_size = 10
  -- config.cell_width = 1
  config.wsl_domains = {
    {
      name = "WSL:Ubuntu",
      distribution = "Ubuntu",
    },
  }
  config.default_domain = "WSL:Ubuntu"
else
  config.font_size = 10.5
end

-- Can be overridden by editors and other applications
config.default_cursor_style = "BlinkingBlock"

-- config.window_background_opacity = 0.80
config.tab_bar_at_bottom = true

-- TODO: add a shortcut to toggle the background
config.background = {
  {
    source = {
      File = wezterm.config_dir .. "/wallpapers/dope-sukuna.png",
    },
    hsb = { hue = 0, saturation = 0, brightness = 0.5 },
  },
  {
    source = {
      Color = "#151515",
    },
    width = "100%",
    height = "100%",
    opacity = 0.9,
    -- hsb = { hue = 1, saturation = 1.8, brightness = 0.7 },
  },
}

-- Terminal style rendering
config.use_fancy_tab_bar = false
config.audible_bell = "Disabled"

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.tab_max_width = 60

config.colors = {
  -- The color of the split lines between panes
  split = "#523E64",

  cursor_bg = "#ffbf00",
  cursor_fg = "#000000",
  cursor_border = "#ffbf00",

  -- selection_fg = "#ffffff",

  selection_bg = "rgba(150,100,0, 0.5)", -- #3a3d41
}

config.inactive_pane_hsb = {
  saturation = 0.9,
  -- brightness = 0.5,
}

-- Extract hostname and current working directory from wezterm uri
-- Figure out the cwd and host of the current pane.
-- This will pick up the hostname for the remote host if your
-- shell is using OSC 7 on the remote host.
local function get_stripped_current_working_dir(cwd_uri)
  if cwd_uri then
    local cwd = ""
    local hostname = ""

    if type(cwd_uri) == "userdata" then
      -- Running on a newer version of wezterm and we have
      -- a URL object here, making this simple!

      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wezterm.hostname()
    else
      -- an older version of wezterm, 20230712-072601-f4abf8fd or earlier,
      -- which doesn't have the Url object
      cwd_uri = cwd_uri:sub(8)
      local slash = cwd_uri:find("/")
      if slash then
        hostname = cwd_uri:sub(1, slash - 1)
        -- and extract the cwd from the uri, decoding %-encoding
        cwd = cwd_uri:sub(slash):gsub("%%(%x%x)", function(hex)
          return string.char(tonumber(hex, 16))
        end)
      end
    end

    -- Remove the domain name portion of the hostname
    local dot = hostname:find("[.]")
    if dot then
      hostname = hostname:sub(1, dot - 1)
    end
    if hostname == "" then
      hostname = wezterm.hostname()
    end

    return { hostname = hostname, cwd = cwd }
  end
end

function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab_title(tab)
  ---@cast title  string

  local elements = {}

  if tab.is_active then
    table.insert(elements, { Foreground = { Color = "#ffffff" } })
    table.insert(elements, { Background = { Color = "#104060" } })
  end

  if hover then
    table.insert(elements, { Foreground = { Color = "#000000" } })
    table.insert(elements, { Background = { Color = "#ffffff" } })
  end

  table.insert(elements, {
    Text = string.format(" [%d] %s  %s  ", tostring(tab.tab_index), title, utf8.char(0xe612)),
  })

  return elements
end)

wezterm.on("update-right-status", function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade

  local cwd_uri = pane:get_current_working_dir()
  local stripped_cwd = get_stripped_current_working_dir(cwd_uri)

  -- The elements to be formatted
  local elements = {}

  -- Translate a cell into elements
  table.insert(elements, { Foreground = { Color = "#ffffff" } })
  table.insert(elements, { Background = { Color = "#104060" } })

  if stripped_cwd ~= nil then
    table.insert(elements, { Text = " " .. stripped_cwd.hostname })
    table.insert(elements, { Text = " " .. utf8.char(0xeb2b) .. "  " })
    table.insert(elements, { Text = stripped_cwd.cwd .. " " })
  end

  window:set_right_status(wezterm.format(elements))
end)

--------------------------------------------------------
-- Keymaps
--------------------------------------------------------

-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  {
    key = "a",
    mods = "LEADER|CTRL",
    action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }),
  },
  {
    key = "s",
    mods = "LEADER",
    action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "v",
    mods = "LEADER",
    action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "h",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action.ActivatePaneDirection("Right"),
  },
  {
    key = "c",
    mods = "LEADER",
    action = wezterm.action.CloseCurrentPane({ confirm = true }),
  },
  {
    key = "z",
    mods = "LEADER",
    action = wezterm.action.TogglePaneZoomState,
  },
  {
    key = "r",
    mods = "LEADER",
    action = wezterm.action.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
  },
  {
    key = "p",
    mods = "LEADER",
    action = wezterm.action.PaneSelect,
  },
  {
    key = "P",
    mods = "LEADER",
    action = wezterm.action.PaneSelect({ mode = "SwapWithActive" }),
  },
  -- { key = "x", mods = "CTRL", action = wezterm.action.ActivateCopyMode },
  {
    key = "r",
    mods = "CMD|SHIFT",
    action = wezterm.action.ReloadConfiguration,
  },

  -- Shouldn't conflict with linux/windows
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },

  {
    key = "F12",
    action = wezterm.action_callback(function(_, pane)
      local tab = pane:tab()
      local panes = tab:panes_with_info()
      if #panes == 1 then
        pane:split({
          direction = "Right",
          size = 0.4,
        })
      elseif not panes[1].is_zoomed then
        panes[1].pane:activate()
        tab:set_zoomed(true)
      elseif panes[1].is_zoomed then
        tab:set_zoomed(false)
        panes[2].pane:activate()
      end
    end),
  },
}

config.key_tables = {
  resize_pane = {
    -- TODO: is it possible to make this value dynamic based on resolution?
    { key = "h", action = wezterm.action.AdjustPaneSize({ "Left", 2 }) },
    { key = "j", action = wezterm.action.AdjustPaneSize({ "Down", 2 }) },
    { key = "k", action = wezterm.action.AdjustPaneSize({ "Up", 2 }) },
    { key = "l", action = wezterm.action.AdjustPaneSize({ "Right", 2 }) },
    {
      key = "r",
      action = wezterm.action.RotatePanes("Clockwise"),
    },
    {
      key = "H",
      action = wezterm.action.MoveTabRelative(-1),
    },
    {
      key = "L",
      action = wezterm.action.MoveTabRelative(1),
    },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  },
}

config.mouse_bindings = {
  -- Disable the default click behavior
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.DisableDefaultAssignment,
  },
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
  -- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wezterm.action.Nop,
  },
}

smart_splits.apply_to_config(config, {
  -- directional keys to use in order of: left, down, up, right
  direction_keys = { "h", "j", "k", "l" },
  -- modifier keys to combine with direction_keys
  modifiers = {
    move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
    resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
  },
})

return config