return {
  "ibhagwan/fzf-lua",
  -- optional for icon support
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    -- optional: setup int .lua/plugins/window-picker.lua
    "s1n7ax/nvim-window-picker",
  },
  -- load immediately
  lazy = false,
  config = function()
    local fzf = require("fzf-lua")
    local fzfconf = require("fzf-lua.config")
    local picker = require("window-picker")

    ---Custom fzf action to pick window when opening files
    ---@diagnostic disable-next-line: unused-local
    local function pick_window(selected, opts)
      -- nothing to do
      if #selected < 1 then
        return fzf.actions.resume()
      end

      -- Convert the entry to an actual path without the leading icon
      local fzfluapath = require("fzf-lua.path")
      local file = fzfluapath.entry_to_file(selected[1])

      local win_id = picker.pick_window({
        filter_rules = {
          include_current_win = true,
          autoselect_one = true,
        },
      })

      if type(win_id) ~= "number" then
        -- should never happen
        print("Selected window id is not a number")
        return
      end

      -- Open the file in a buffer and select the window
      local bufnr = vim.fn.bufadd(file.path)
      vim.api.nvim_win_set_buf(win_id, bufnr)
    end

    -- -- Set the action name or it will show as 'table <hex code>'
    fzfconf.set_action_helpstr(pick_window, "pick_window")

    fzf.setup({
      actions = {
        -- Retain the original actions, then override (replaces all by default)
        files = {
          true, -- inherit defaults
          ["ctrl-w"] = {
            fn = pick_window,
          },
        },
      },
    })

    -- Keymaps
    local map = vim.keymap.set

    map("n", "<leader><leader>", ":FzfLua<cr>", { desc = "FzfLua", nowait = true })
    map("v", "<leader>f", fzf.grep_visual, { desc = "Search selection" })
    map("n", "<leader>fr", fzf.resume, { desc = "Search resume" })
    map("n", "<leader>ff", fzf.files, { desc = "Search files" })
    map("n", "<leader>/", fzf.grep_curbuf, { desc = "Search current buffer" })
    map("n", "<leader>fh", fzf.helptags, { desc = "Search help" })
    map("n", "<leader>fH", fzf.manpages, { desc = "Search man pages" })
    map("n", "<leader>fm", fzf.marks, { desc = "Search marks" })
    map("n", "<leader>fg", function()
      -- ignore some project files by default
      local ignore_list = { "!package-lock.json", "!yarn.lock" }
      local ignore_opt = ""

      for _, value in ipairs(ignore_list) do
        ignore_opt = string.format("%s --glob '%s'", ignore_opt, value)
      end

      fzf.live_grep_glob({
        rg_opts = string.format("%s %s", ignore_opt, fzf.defaults.grep.rg_opts),
      })
    end, { desc = "Search project" })

    -- keep it similar to code actions (la)
    map("n", "<leader>ls", fzf.spell_suggest, { desc = "Search spell suggestions" })
  end,
}
