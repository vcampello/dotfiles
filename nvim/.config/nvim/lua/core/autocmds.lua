local core_group = vim.api.nvim_create_augroup("core", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = core_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- FIXME: can it be setup so if I press enter again on a comment line it removes the line?
--[[
-- some comment
--
<enter>
-- some comment
]]

vim.api.nvim_create_autocmd("BufRead", {
  group = core_group,
  pattern = "*.json",
  callback = function(ev)
    -- vim.print(ev)
    local max_filesize_in_bytes = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.uv.fs_stat, ev.match) -- ev.match would also work in this case

    if ok and stats and stats.size > max_filesize_in_bytes then
      -- stop it here if jq is missing before retrieving the line content
      if vim.fn.executable("jq") == 0 then
        vim.notify("jq not found to format large JSON file", vim.log.levels.WARN)
        return
      end

      if #vim.api.nvim_get_current_line() > 300 then
        vim.cmd("%!jq .") -- this may conflict with formatters
        vim.notify("Large JSON file formatted", vim.log.levels.INFO)
        -- vim.cmd.write() -- if it should be safed
      end
    end
  end,
})
