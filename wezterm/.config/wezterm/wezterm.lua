-- wezterm api
local wez = require("wezterm")
local mux = wez.mux
local config = wez.config_builder()

-- my stuff
local theme = require("theme")
local utils = require("utils")

--------------------------------------------------------------------------------
--- OS specific config
--------------------------------------------------------------------------------
if utils.is_macos(wez.target_triple) then
  -- macOS detected
  config.font_size = 14
  config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
  -- prevent post suspend crash on macos
  -- https://github.com/wezterm/wezterm/issues/7291
  config.front_end = "WebGpu"
elseif utils.is_linux(wez.target_triple) then
  -- linux detected
  config.font_size = 10.5
  config.window_decorations = "RESIZE"
elseif utils.is_windows(wez.target_triple) then
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

--------------------------------------------------------------------------------
--- font rendering
--------------------------------------------------------------------------------
-- Disable as the pop-up comes up way too often
config.warn_about_missing_glyphs = false
config.font = wez.font("Victor Mono", { weight = "DemiBold", stretch = "Normal", style = "Normal" })
-- fix strike through position
-- might not work at all until this is set -> https://wezfurlong.org/wezterm/faq.html#how-do-i-enable-undercurl-curly-underlines
config.strikethrough_position = "0.6cell"
-- disable ligatures
config.harfbuzz_features = { "calt=0" }

--------------------------------------------------------------------------------
--- window decoration
--------------------------------------------------------------------------------
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 60
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

--------------------------------------------------------------------------------
--- misc
--------------------------------------------------------------------------------
config.audible_bell = "Disabled"

--------------------------------------------------------------------------------
--- theming
--------------------------------------------------------------------------------
config.color_scheme = "nord"
-- Can be overridden by editors and other applications
config.default_cursor_style = "BlinkingBlock"

config.colors = {
  -- The color of the split lines between panes
  split = theme.COLORS.white,
  cursor_bg = theme.COLORS.bloodOrange,
  cursor_fg = theme.COLORS.white,
  cursor_border = theme.COLORS.amber,

  selection_bg = theme.COLORS.nordic_gray1,
  selection_fg = theme.COLORS.nordic_fg_bright,
  tab_bar = {
    background = theme.palette.status_bar.bg,
  },
}

-- TODO: add a shortcut to toggle the background
config.background = {
  {
    source = {
      -- File = wez.config_dir .. "/wallpapers/dark-souls-ii-17.jpg",
      File = wez.config_dir .. "/wallpapers/sunset-sakura-tree.jpg",
    },
    hsb = { hue = 1, saturation = 1, brightness = 0.4 },
  },
  {
    source = {
      Color = theme.COLORS.nordic_gray1,
    },
    width = "100%",
    height = "100%",
    opacity = 0.85,
    hsb = { hue = 1, saturation = 1.2, brightness = 0.3 },
  },
}

--------------------------------------------------------------------------------
--- mouse bindings
--------------------------------------------------------------------------------
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

return config
