return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  -- Optional dependency
  dependencies = {
    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup({
          opts = {
            -- Defaults
            enable_close = true, -- Auto close tags
            enable_rename = true, -- Auto rename pairs of tags
            enable_close_on_slash = true, -- Auto close on trailing </
          },
        })
      end,
    },
  },
  ---@module 'nvim-autopairs
  ---@type nvim-ts-autotag.Opts
  opts = {
    enable_check_bracket_line = true,
  },
}
