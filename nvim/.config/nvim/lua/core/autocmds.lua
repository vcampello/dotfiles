local core_group = vim.api.nvim_create_augroup("core", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = core_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable some annoying comment formatting",
  group = core_group,
  pattern = "*",
  callback = function(ev)
    -- ignore the following matches
    local blacklist = { "snack" }
    for _, value in ipairs(blacklist) do
      if string.find(ev.match, value) then
        return
      end
    end

    -- We never want the following options
    vim.opt_local.formatoptions:remove({
      -- Auto-wrap text using 'textwidth'
      "t",
      -- Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.
      "c",
      -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
      "o",
      -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
      "r",
    })
  end,
})
