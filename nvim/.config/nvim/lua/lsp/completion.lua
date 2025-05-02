---@diagnostic disable: missing-fields
return {
  "saghen/blink.cmp",
  lazy = false, -- lazy loading handled internally
  -- optional: provides snippets for the snippet source
  dependencies = {
    "rafamadriz/friendly-snippets",
    "folke/lazydev.nvim",
  },

  -- use a release tag to download pre-built binaries
  version = "v0.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = "default" },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    completion = {
      -- Disable auto brackets
      accept = { auto_brackets = { enabled = true } },
      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = false },
      -- Show documentation when selecting a completion item
      documentation = { auto_show = true, auto_show_delay_ms = 250 },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        lsp = {
          score_offset = 10,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          -- make lazydev completions top priority (see `:h blink.cmp`)
          score_offset = 100,
        },
      },
    },

    -- FIXME: figure out how this interacts with noice and causes two signature windows to popup
    -- experimental signature help support
    -- signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  -- allows extending the enabled_providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}
