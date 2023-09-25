return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    {
      "s1n7ax/nvim-window-picker",
      version = "2.*",
      config = function()
        require("window-picker").setup({
          filter_rules = {
            include_current_win = false,
            autoselect_one = true,
            -- filter using buffer options
            bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { "neo-tree", "neo-tree-popup", "notify" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { "terminal", "quickfix" },
            },
          },
        })
      end,
    },
  },
  opts = {
    autoselect_one = false,
    include_current = false,
    filter_rules = {
      -- filter using buffer options
      bo = {
        -- if the file type is one of following, the window will be ignored
        filetype = { "neo-tree", "neo-tree-popup", "notify" },
        -- if the buffer type is one of following, the window will be ignored
        buftype = { "terminal", "quickfix" },
      },
    },
    other_win_hl_color = "#e0af68",
    fg_color = "#333333",
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    window = {
      position = "right",
      mappings = {
        ["S"] = "split_with_window_picker",
        ["s"] = "vsplit_with_window_picker",
      },
    },
    filesystem = {
      follow_current_file = true,
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false, -- only works on Windows for hidden files/directories
        hide_by_name = {
          "node_modules",
        },
        never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
          ".DS_Store",
          "thumbs.db",
        },
        never_show_by_pattern = { -- uses glob style patterns
          --".null-ls_*",
        },
      },
    },
  },
  config = function()
    -- Mappings
    vim.keymap.set("n", "<leader>nf", "<cmd>:Neotree filesystem reveal right<cr>", { desc = "[N]eotree [F]ilesystem" })
    vim.keymap.set("n", "<leader>nb", "<cmd>:Neotree buffers toggle right<cr>", { desc = "[N]eotree [B]uffers" })
    vim.keymap.set("n", "<leader>ng", "<cmd>:Neotree git_status toggle right<cr>", { desc = "[N]eotree [G]it" })
    vim.keymap.set("n", "<leader>nc", "<cmd>:Neotree close right<cr>", { desc = "[N]eotree [C]lose" })
  end,
}
