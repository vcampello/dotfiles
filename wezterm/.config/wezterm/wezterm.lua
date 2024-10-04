-- Pull in the wezterm API
local wez = require("wezterm")
local mux = wez.mux

local shared = require("shared")
local theme = require("theme")

-- This table will hold the configuration.
local config = wez.config_builder()

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

if wez.target_triple == "aarch64-apple-darwin" or wez.target_triple == "x86_64-apple-darwin" then
  -- macOS detected
  config.font_size = 14
elseif wez.target_triple == "x86_64-unknown-linux-gnu" then
  -- linux detected
  config.font_size = 10.5
  -- config.window_decorations = "RESIZE"
elseif wez.target_triple == "x86_64-pc-windows-msvc" then
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
config.unix_domains = {
  {
    name = "unix",
  },
}

--TEMP: disabled as it was causing rendering lag on macos
-- This causes `wezterm` to act as though it was started as
-- `wezterm connect unix` by default, connecting to the unix
-- domain on startup.
-- If you prefer to connect manually, leave out this line.
-- config.default_gui_startup_args = { "connect", "unix" }

-- Can be overridden by editors and other applications
config.default_cursor_style = "BlinkingBlock"

-- config.window_background_opacity = 0.80
config.tab_bar_at_bottom = true

-- TODO: add a shortcut to toggle the background
config.background = {
  {
    source = {
      File = wez.config_dir .. "/wallpapers/dope-sukuna.png",
    },
    hsb = { hue = 0, saturation = 0, brightness = 0.5 },
  },
  {
    source = {
      Color = theme.COLORS.black,
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
  cursor_bg = theme.COLORS.amber,
  cursor_fg = theme.COLORS.black,
  cursor_border = theme.COLORS.amber,

  -- selection_fg = "#ffffff",

  selection_bg = "rgba(150,100,0, 0.5)", -- #3a3d41
  tab_bar = {
    background = theme.COLORS.black,
  },
}

config.inactive_pane_hsb = {
  saturation = 0.9,
  -- brightness = 0.5,
}

-- Extract hostname and current working directory from wezterm uri
-- Figure out the cwd and host of the current pane.
-- This will pick up the hostname for the remote host if your
-- shell is using OSC 7 on the remote host.
---@return { hostname: string, cwd: string }
local function get_stripped_current_working_dir(cwd_uri)
  local cwd = ""
  local hostname = ""
  if cwd_uri then
    if type(cwd_uri) == "userdata" then
      -- Running on a newer version of wezterm and we have
      -- a URL object here, making this simple!

      cwd = cwd_uri.file_path
      hostname = cwd_uri.host or wez.hostname()
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
      hostname = wez.hostname()
    end
  end
  return { hostname = hostname, cwd = cwd }
end

---Get tab title
---@param tab_info any
---@return string
local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end

wez.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab_title(tab)

  local elements = shared.build_elements({ { tostring(tab.tab_index), " ", title } }, {
    -- when active set background to yellow and text to amber
    bg = tab.is_active and theme.COLORS.amber or theme.COLORS.gray,
    fg = tab.is_active and theme.COLORS.black or theme.COLORS.white,
  })

  return elements
end)

wez.on("update-status", function(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  local stripped_cwd = get_stripped_current_working_dir(cwd_uri)

  local right = shared.build_elements({
    { "󰉌 ", stripped_cwd.cwd },
    { "󰞇 ", (os.getenv("USER") or "anon") },
    { "󰌢 ", stripped_cwd.hostname },
  }, {
    bg = theme.COLORS.gray,
    fg = theme.COLORS.white,
  })
  -- prevent errors on lua repl
  window:set_right_status(wez.format(right))

  local workspaces = shared.build_elements({
    { tostring(#mux.get_workspace_names()), " ", window:active_workspace() },
  }, {
    bg = theme.COLORS.red,
    fg = theme.COLORS.white,
  })

  local default_mode = "normal"
  local mode_text = window:active_key_table() or default_mode
  local mode_icon = mode_text == default_mode and "󰨙 " or "󰔡 "
  local mode_bg = mode_text == default_mode and theme.COLORS.black or theme.COLORS.purple
  local mode_fg = theme.COLORS.white

  local mode = shared.build_elements({
    { mode_icon, mode_text:upper() },
  }, {
    bg = mode_bg,
    fg = mode_fg,
  })

  local left = shared.concat_array(mode, workspaces)

  window:set_left_status(wez.format(left))
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
    action = wez.action.SendKey({ key = "a", mods = "CTRL" }),
  },
  {
    key = "s",
    mods = "LEADER",
    action = wez.action.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "v",
    mods = "LEADER",
    action = wez.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "h",
    mods = "LEADER",
    action = wez.action.ActivatePaneDirection("Left"),
  },
  {
    key = "j",
    mods = "LEADER",
    action = wez.action.ActivatePaneDirection("Down"),
  },
  {
    key = "k",
    mods = "LEADER",
    action = wez.action.ActivatePaneDirection("Up"),
  },
  {
    key = "l",
    mods = "LEADER",
    action = wez.action.ActivatePaneDirection("Right"),
  },
  {
    key = "c",
    mods = "LEADER",
    action = wez.action.CloseCurrentPane({ confirm = true }),
  },
  {
    key = "z",
    mods = "LEADER",
    action = wez.action.TogglePaneZoomState,
  },
  {
    key = "r",
    mods = "LEADER",
    action = wez.action.ActivateKeyTable({ name = "resize_pane", one_shot = false }),
  },
  {
    key = "p",
    mods = "LEADER",
    action = wez.action.PaneSelect,
  },
  {
    key = "P",
    mods = "LEADER",
    action = wez.action.PaneSelect({ mode = "SwapWithActive" }),
  },
  -- { key = "x", mods = "CTRL", action = wezterm.action.ActivateCopyMode },
  {
    key = "r",
    mods = "CMD|SHIFT",
    action = wez.action.ReloadConfiguration,
  },

  -- Shouldn't conflict with linux/windows
  -- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
  { key = "LeftArrow", mods = "OPT", action = wez.action({ SendString = "\x1bb" }) },
  -- Make Option-Right equivalent to Alt-f; forward-word
  { key = "RightArrow", mods = "OPT", action = wez.action({ SendString = "\x1bf" }) },
  {
    key = ",",
    mods = "LEADER",
    action = wez.action.PromptInputLine({
      description = "Enter new name for tab",
      action = wez.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
  {
    key = ".",
    mods = "LEADER",
    action = wez.action.PromptInputLine({
      description = "Enter new name for workspace",
      action = wez.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          mux.rename_workspace(mux.get_active_workspace(), line)
        end
      end),
    }),
  },
  {
    key = "m",
    mods = "LEADER",
    action = wez.action.ShowLauncherArgs({
      flags = "FUZZY|WORKSPACES",
    }),
  },
  {
    key = "n",
    mods = "LEADER",
    action = wez.action.PromptInputLine({
      description = wez.format({
        { Attribute = { Intensity = "Bold" } },
        { Text = "Enter name for new workspace" },
      }),
      action = wez.action_callback(function(window, pane, line)
        -- line will be `nil` if they hit escape without entering anything
        -- An empty string if they just hit enter
        -- Or the actual line of text they wrote
        if line then
          window:perform_action(
            wez.action.SwitchToWorkspace({
              name = #line > 0 and line or "unnamed",
            }),
            pane
          )
        end
      end),
    }),
  },
  {
    key = "F12",
    action = wez.action_callback(function(_, pane)
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
    { key = "h", action = wez.action.AdjustPaneSize({ "Left", 2 }) },
    { key = "j", action = wez.action.AdjustPaneSize({ "Down", 2 }) },
    { key = "k", action = wez.action.AdjustPaneSize({ "Up", 2 }) },
    { key = "l", action = wez.action.AdjustPaneSize({ "Right", 2 }) },
    {
      key = "r",
      action = wez.action.RotatePanes("Clockwise"),
    },
    {
      key = "H",
      action = wez.action.MoveTabRelative(-1),
    },
    {
      key = "L",
      action = wez.action.MoveTabRelative(1),
    },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
  },
  navigate = {
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter", action = "PopKeyTable" },
    -- the rest will be added by the loop below
  },
}

-- enter tab/workspace navigation mode in vim style hl for tabs and and jk for workspaces
local navigation_actions = {
  j = wez.action.SwitchWorkspaceRelative(1),
  k = wez.action.SwitchWorkspaceRelative(-1),
  h = wez.action.ActivateTabRelative(-1),
  l = wez.action.ActivateTabRelative(1),
}

for key, mapped_action in pairs(navigation_actions) do
  -- insert keymaps
  table.insert(config.keys, {
    key = key,
    mods = "LEADER",
    -- action = wez.action.ActivateKeyTable({ name = "navigate", one_shot = false }),
    action = wez.action.Multiple({
      -- prevent nested keytables
      wez.action.ClearKeyTableStack,
      -- trigger the action first before entering the key table
      mapped_action,
      -- enter navigate mode
      wez.action.ActivateKeyTable({ name = "navigate", one_shot = false }),
    }),
  })

  -- insert into key_tables
  table.insert(config.key_tables.navigate, { key = key, action = mapped_action })
end

config.mouse_bindings = {
  -- Disable the default click behavior
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wez.action.DisableDefaultAssignment,
  },
  -- Ctrl-click will open the link under the mouse cursor
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wez.action.OpenLinkAtMouseCursor,
  },
  -- Disable the Ctrl-click down event to stop programs from seeing it when a URL is clicked
  {
    event = { Down = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = wez.action.Nop,
  },
}

local smart_splits = wez.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
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
