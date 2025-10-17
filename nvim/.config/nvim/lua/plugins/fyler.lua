return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-mini/mini.icons" },
  -- opts = {},
  config = function()
    local fyler = require("fyler")
    fyler.setup({ default_explorer = true, icon_provider = "nvim_web_devicons" })
    vim.keymap.set({ "n" }, "<leader>o", function()
      fyler.open({ kind = "float" })
    end, {
      desc = "Open Fyler",
    }
)
  end,
}
