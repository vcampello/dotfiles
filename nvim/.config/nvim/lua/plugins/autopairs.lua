return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  -- Optional dependency
  dependencies = {
    "hrsh7th/nvim-cmp",
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
  config = function()
    require("nvim-autopairs").setup({
      -- check if the bracket is actually needed aka prevent {}}
      enable_check_bracket_line = true,
    })
    -- If you want to automatically add `(` after selecting a function or method
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
