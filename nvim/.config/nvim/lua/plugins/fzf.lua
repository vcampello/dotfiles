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
    local fzfluapath = require("fzf-lua.path")

    ---Custom fzf action to pick window when opening files
    ---@diagnostic disable-next-line: unused-local
    local function pick_window(selected, opts)
      -- nothing to do
      if #selected < 1 then
        return fzf.actions.resume()
      end

      -- Convert the entry to an actual path without the leading icon
      local file = fzfluapath.entry_to_file(selected[1])

      -- hide ui so it's easier to see the picker legends
      fzf.win.hide()
      local win_id = picker.pick_window({
        filter_rules = {
          include_current_win = true,
          autoselect_one = true,
        },
      })

      if type(win_id) ~= "number" then
        -- should never happen
        vim.print("Selected window id is not a number")
        -- show the ui again
        fzf.win.unhide()
        return
      end

      -- Open the file in a buffer and select the window
      local bufnr = vim.fn.bufadd(file.path)
      vim.api.nvim_win_set_buf(win_id, bufnr)
    end

    ---Diff files in a split view
    local function diff_files(selected, opts)
      -- nothing to do
      if #selected < 2 or #selected > 2 then
        vim.notify("Select two files to diff", vim.log.levels.WARN)
        return fzf.actions.resume()
      end

      local files = {}
      for _, entry in ipairs(selected) do
        -- Convert the entry to an actual path without the leading icon
        table.insert(files, fzfluapath.entry_to_file(entry, {}, false).path)
      end

      -- explanation:
      -- use all filepaths as arguments
      -- open all files in a vertical split
      -- bind the cursor on every buffer
      -- diff all buffers
      local cmd = "args " .. table.concat(files, " ") .. " | vertical all | windo set cursorbind | diffthis"
      vim.cmd(cmd)
    end

    -- -- Set the action name or it will show as 'table <hex code>'
    fzfconf.set_action_helpstr(pick_window, "pick_window")
    fzfconf.set_action_helpstr(diff_files, "diff_files")

    fzf.setup({
      winopts = {
        -- fullscreen = true,
      },
      actions = {
        -- Retain the original actions, then override (replaces all by default)
        files = {
          true, -- inherit defaults
          ["ctrl-w"] = {
            fn = pick_window,
          },
          ["ctrl-d"] = {
            fn = diff_files,
          },
        },
      },
      previewers = {
        builtin = {
          -- disable image previews for now. It can cause wezterm to hang and images to be permanently drawn on the buffer/neovim
          snacks_image = { enabled = false },
        },
      },
    })

    -- Keymaps
    local map = vim.keymap.set

    map("n", "<leader><leader>", fzf.buffers, { desc = "Buffers", nowait = true })
    map("n", "<leader><leader><leader>", ":FzfLua<cr>", { desc = "FzfLua", nowait = true })
    map("v", "<leader>f", fzf.grep_visual, { desc = "Search selection" })
    map("n", "<leader>fr", fzf.resume, { desc = "Search resume" })
    map("n", "<leader>ff", fzf.files, { desc = "Search files" })
    map("n", "<leader>/", fzf.grep_curbuf, { desc = "Search current buffer" })
    map("n", "<leader>fm", fzf.marks, { desc = "Search marks" })
    map("n", "<leader>fj", fzf.jumps, { desc = "Search jumps" })
    map("n", "<leader>fo", fzf.git_status, { desc = "Search git status" })
    map("n", "<leader>fO", fzf.oldfiles, { desc = "Search old files" })
    map("n", "<leader>fq", fzf.quickfix, { desc = "Search quickfix" })
    map("n", "<leader>fg", function()
      -- ignore some project files by default
      -- make it interatable through :let g:fzf_ignore_list
      local fzf_ignore_list = vim.g.fzf_ignore_list or { "!package-lock.json", "!yarn.lock" }
      if not vim.g.fzf_ignore_list then
        vim.g.fzf_ignore_list = fzf_ignore_list
      end
      local ignore_opt = ""

      for _, value in ipairs(fzf_ignore_list) do
        ignore_opt = string.format("%s --glob '%s'", ignore_opt, value)
      end

      fzf.live_grep({
        rg_opts = string.format("%s %s", ignore_opt, fzf.defaults.grep.rg_opts),
      })
    end, { desc = "Search project" })

    -- replace original suggestions keymap
    map("n", "z=", fzf.spell_suggest, { desc = "Search spell suggestions", nowait = true })
  end,
}
