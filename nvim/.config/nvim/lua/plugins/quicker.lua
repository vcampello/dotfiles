return {
  "stevearc/quicker.nvim",
  event = "FileType qf",
  ---@module "quicker"
  ---@type quicker.SetupOptions
  opts = {},
  config = function()
    vim.keymap.set("n", "<leader>q", function()
      require("quicker").toggle()
    end, {
      desc = "Toggle quickfix",
    })
    -- vim.keymap.set("n", "<leader>l", function()
    --   require("quicker").toggle({ loclist = true })
    -- end, {
    --   desc = "Toggle loclist",
    -- })
    require("quicker").setup({
      keys = {
        {
          ">",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "<",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    })

    vim.keymap.set("n", "]q", function()
      if #vim.fn.getqflist() == 0 then
        return
      end

      vim.cmd.cnext()
    end, { desc = "Previous quickfix item" })

    vim.keymap.set("n", "[q", function()
      if #vim.fn.getqflist() == 0 then
        return
      end

      vim.cmd.cprev()
    end, { desc = "Next quickfix item" })
  end,
}