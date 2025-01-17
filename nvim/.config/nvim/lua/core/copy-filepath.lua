local M = {}

---@class Actions
M.actions = {}

function M.actions.filename()
  return vim.fn.expand("%:t")
end

function M.actions.absolute()
  return vim.fn.expand("%:p")
end

function M.actions.from_cwd()
  return vim.fn.expand("%")
end

function M.actions.from_home()
  return vim.fn.expand("%:~")
end

function M.setup()
  vim.api.nvim_create_user_command("CopyFilePath", function(opts)
    local value = M.actions[opts.fargs[1]]()
    vim.fn.setreg("+", value)
    vim.notify("Copied filepath " .. value, vim.log.levels.INFO)
  end, {
    desc = "Copy file path",
    nargs = 1,
    complete = function()
      return vim.tbl_keys(M.actions)
    end,
  })
end

return M
