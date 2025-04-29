return {
  "f-person/git-blame.nvim",
  enabled = false,
  config = function()
    local git_blame = require("gitblame")
    git_blame.setup({
      display_virtual_text = true,
      set_extmark_options = {
        hl_mode = "combine",
      },
    })
  end,
}
