-- wezterm api
local wez = require("wezterm")
local config = wez.config_builder()

-- my stuff
local theme = require("theme")
local utils = require("utils")

--------------------------------------------------------------------------------
--- OS specific config
--------------------------------------------------------------------------------
if utils.is_macos(wez.target_triple) then
    -- MacOS detected
    config.font_size = 14
    config.default_prog = { "/opt/homebrew/bin/fish", "-l" }
    -- prevent post suspend crash on MacOS
    -- https://github.com/wezterm/wezterm/issues/7291
    config.front_end = "WebGpu"
elseif utils.is_linux(wez.target_triple) then
    -- linux detected
    config.font_size = 11
    config.line_height = 1.0
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
config.font = wez.font("IoskeleyMono Nerd Font")
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
config.color_scheme = "Monokai Dark (Gogh)"
-- kintsugi: https://github.com/metalelf0/kintsugi-nvim/blob/6c8b881e6aea8ee1e3361a00858b5b1a3488d885/extras/wezterm/kintsugi.lua
config.colors = {
    foreground = "#cacac2",
    background = "#131314",

    cursor_bg = "#d4a943",
    cursor_border = "#d4a943",
    cursor_fg = "#0e0e0e",

    selection_bg = "#47464c",
    selection_fg = "#dddddd",

    scrollbar_thumb = "#33352d",
    split = "#2a2a28",

    ansi = {
        "#131314", -- black
        "#b38f8f", -- red
        "#a3be8c", -- green
        "#ebcb8b", -- yellow
        "#6c7a8a", -- blue
        "#b3a3d3", -- magenta
        "#6ac6f2", -- cyan
        "#dddddd", -- white
    },
    brights = {
        "#444444", -- bright black
        "#d9a6a6", -- bright red
        "#c3de9c", -- bright green
        "#fbe4a8", -- bright yellow
        "#8fa3b3", -- bright blue
        "#d3a3d3", -- bright magenta
        "#8ac6f2", -- bright cyan
        "#ffffff", -- bright white
    },

    tab_bar = {
        background = "#131314",
        active_tab = {
            bg_color = "#161618",
            fg_color = "#dddddd",
            intensity = "Bold",
        },
        inactive_tab = {
            bg_color = "#131314",
            fg_color = "#969b8c",
        },
        inactive_tab_hover = {
            bg_color = "#20201f",
            fg_color = "#c9c4b8",
            italic = false,
        },
        new_tab = {
            bg_color = "#131314",
            fg_color = "#969b8c",
        },
        new_tab_hover = {
            bg_color = "#20201f",
            fg_color = "#dbad49",
        },
    },

    visual_bell = "#b8943a",

    indexed = {
        [16] = "#d4a943",
        [17] = "#b8943a",
    },
}
-- Can be overridden by editors and other applications
config.default_cursor_style = "BlinkingBlock"

-- config.colors = {
--     -- The color of the split lines between panes
--     split = theme.COLORS.white,
--     cursor_bg = theme.COLORS.bloodOrange,
--     cursor_fg = theme.COLORS.white,
--     cursor_border = theme.COLORS.amber,
--
--     selection_bg = theme.COLORS.nordic_gray1,
--     selection_fg = theme.COLORS.nordic_fg_bright,
--     tab_bar = {
--         background = theme.palette.status_bar.bg,
--     },
-- }

-- TODO: add a shortcut to toggle the background
config.background = {
    {
        source = {
            -- File = wez.config_dir .. "/wallpapers/dark-souls-ii-17.jpg",
            -- File = wez.config_dir .. "/wallpapers/sunset-sakura-tree.jpg",
            File = wez.config_dir .. "/wallpapers/cosmic-horror.jpg",
        },
        hsb = { hue = 1, saturation = 2.0, brightness = 0.4 },
    },
    {
        source = {
            -- Color = theme.COLORS.brown,
            Color = "#131314",
        },
        width = "100%",
        height = "100%",
        opacity = 0.80,
        hsb = { hue = 1.0, saturation = 1.0, brightness = 0.3 },
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
