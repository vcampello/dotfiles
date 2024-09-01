return {
  "folke/lazydev.nvim",
  dependencies = {
    "justinsgithub/wezterm-types",
    "LelouchHe/xmake-luals-addon",
  },
  ft = "lua", -- only load on lua files
  opts = {
    library = {
      -- Or relative, which means they will be resolved from the plugin dir.
      "luvit-meta/library",
      { path = "luvit-meta/library", words = { "vim%.uv" } },
      -- Needs `justinsgithub/wezterm-types` to be installed
      { path = "wezterm-types", mods = { "wezterm" } },
      -- Load the xmake types when opening file named `xmake.lua`
      -- Needs `LelouchHe/xmake-luals-addon` to be installed
      { path = "xmake-luals-addon/library", files = { "xmake.lua" } },
    },
  },
}
