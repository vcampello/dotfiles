local M = {
  name = "Simple to-do list",
  desc = "A simple to-do list accessible in any vim instance and with with multitab support",
  config = {
    --- Filepath for todo list markdown file
    filepath = vim.fn.stdpath("data") .. "/my-todo.md",
    keymap = {
      quick_close = "q",
    },
  },
  actions = {},
}

---Track if it's already open somwehere
---@type integer | nil
local known_winid = nil

---Autocommand group for todo-list
local todo_augroup = vim.api.nvim_create_augroup("TodolistGroup", { clear = true })

---Open to-do list window
---@return integer winid
local function create_and_open()
  local bufnr = vim.fn.bufadd(M.config.filepath)
  -- ensure buffer is wiped out when it's hidden (prevents jumpting to it when using c-o)
  -- vim.bo[bufnr].bufhidden = "wipe" -- conflicts with markview.nvim
  -- prevent buffer from being listed by :ls
  vim.bo[bufnr].buflisted = false

  -- current window dimensions
  local win_width = vim.api.nvim_list_uis()[1].width
  local win_height = vim.api.nvim_list_uis()[1].height

  -- floating window dimensions
  local width = math.floor(win_width * 0.5)
  local height = math.floor(win_height * 0.7)

  -- anchor offset to centre it
  local col = math.floor((win_width / 2) - (width / 2))
  local row = math.floor((win_height / 2) - (height / 2))

  -- open floating window
  local winid = vim.api.nvim_open_win(bufnr, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    title = " To-do ",
    title_pos = "center",
    border = "rounded",
  })

  vim.api.nvim_create_autocmd({ "BufWinLeave", "BufLeave", "WinClosed" }, {
    desc = "Automatically close the floating window and prevent it being used for other files",
    group = todo_augroup,
    buffer = bufnr,
    once = false,
    callback = function()
      M.actions.close()
    end,
  })

  vim.api.nvim_create_autocmd({ "ModeChanged" }, {
    desc = "automatically save buffer when going back to normal mode",
    group = todo_augroup,
    buffer = bufnr,
    once = false,
    callback = function(ev)
      if string.match(ev.match, "%a:n") then
        vim.cmd.write()
      end
    end,
  })

  -- Quick escape keymap
  vim.keymap.set({ "n" }, M.config.keymap.quick_close, function()
    M.actions.close()
  end, {
    buffer = bufnr,
    desc = "Quick close to-do list",
    nowait = true,
    silent = true,
  })

  -- focus
  vim.api.nvim_set_current_win(winid)

  return winid
end

---Close floating window
function M.actions.close()
  if known_winid ~= nil and vim.api.nvim_win_is_valid(known_winid) then
    vim.api.nvim_win_close(known_winid, true)
  end
  known_winid = nil
end

---Check if is open on tab
---@return boolean
function M.is_open_on_tab(tabid)
  for _, value in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
    if value == known_winid then
      return true
    end
  end

  return false
end

---Open window
function M.actions.open()
  local tabid = vim.api.nvim_get_current_tabpage()

  if not M.is_open_on_tab(tabid) then
    known_winid = create_and_open()
  end
end

---Toggle floating window
function M.actions.toggle()
  local tabid = vim.api.nvim_get_current_tabpage()

  if M.is_open_on_tab(tabid) then
    M.actions.close()
  else
    -- attemp to close
    M.actions.close()

    -- open and store window id to prevent opening it again
    known_winid = create_and_open()
  end
end

---Dump current known location
function M.actions.debug()
  if known_winid ~= nil then
    print("Open on window: " .. known_winid)
  else
    print("Not open")
  end
end

---Initialise plugin
function M.setup()
  -- Setup commands
  vim.api.nvim_create_user_command("TodoList", function(opts)
    local action_name = opts.fargs[1]
    if M.actions[action_name] then
      M.actions[action_name](opts)
    end
  end, {
    nargs = 1,
    complete = function()
      return vim.tbl_keys(M.actions)
    end,
  })

  -- default keymap
  vim.keymap.set("n", "<leader>T", M.actions.toggle, { desc = "Toggle to-do list", silent = true })
end

return M
