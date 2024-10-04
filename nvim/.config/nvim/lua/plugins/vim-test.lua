return {
  "vim-test/vim-test",
  config = function()
    vim.cmd("let test#strategy = 'neovim'")
    vim.cmd("let test#neovim#term_position = 'botright vsplit'")

    local action_popup = function()
      require("fzf-lua").fzf_exec({
        "TestNearest",
        "TestFile",
        "TestSuite",
        "TestLast",
        "TestVisit",
      }, {
        prompt = "Test runner> ",
        actions = {
          ["enter"] = function(selected, opts)
            if #selected == 0 or #selected > 1 then
              return
            end
            vim.cmd(selected[1])
          end,
        },
      })
    end

    vim.keymap.set({ "n" }, "<leader>t", action_popup, { desc = "Test runner actions" })
  end,
}
