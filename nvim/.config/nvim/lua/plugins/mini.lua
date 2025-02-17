return {
  "echasnovski/mini.nvim",
  -- enable tsx commts
  dependencies = {
    "JoosepAlviste/nvim-ts-context-commentstring",
    opts = {
      enable_autocmd = false,
    },
  },
  config = function()
    -- Use defaults
    -- require("mini.cursorword").setup()
    -- require("mini.indentscope").setup()
    -- require("mini.move").setup() -- conflicts with smart-splits. Let's see if I actually need it
    -- require("mini.pairs").setup()
    require("mini.surround").setup({
      custom_surroundings = {
        ["("] = { input = { "%b()", "^.().*().$" }, output = { left = "(", right = ")" } },
        ["["] = { input = { "%b[]", "^.().*().$" }, output = { left = "[", right = "]" } },
        ["{"] = { input = { "%b{}", "^.().*().$" }, output = { left = "{", right = "}" } },
        ["<"] = { input = { "%b<>", "^.().*().$" }, output = { left = "<", right = ">" } },
      },
    })
    require("mini.splitjoin").setup()

    require("mini.comment").setup({
      options = {
        custom_commentstring = function()
          return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
        end,
      },
    })

    -- mini.bufremove
    local MiniBufRemove = require("mini.bufremove")
    MiniBufRemove.setup()
    vim.keymap.set({ "n", "i" }, "<C-c>", MiniBufRemove.wipeout, { desc = "Wipeout current buffer" })
  end,
}
