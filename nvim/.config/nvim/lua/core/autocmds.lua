local core_group = vim.api.nvim_create_augroup("core", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = core_group,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Do not auto comment next line for single comments",
  group = core_group,
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "lua", "c" },
  callback = function()
    -- ignore the following matches
    -- local blacklist = { "snack" }
    -- for _, value in ipairs(blacklist) do
    --   if string.find(ev.match, value) then
    --     return
    --   end
    -- end

    -- do not auto comment next line for single comments
    vim.opt_local.comments:remove({
      "://",
      ":--",
    })
  end,
})

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
