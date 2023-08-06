--- Plugin commands
---
local conf = require("neofs.conf")
local const = require("neofs.conf")
local tree = require("neofs.tree")
local view = require("neofs.view")

local M = {}

M.show = function()
  -- local state = state.get()
  -- state.view:show()
  -- state.tree:load(cwd())

  error("not implemented")
end

M.close = function()
  -- local state = state.get()
  -- state.view:close()
  error("not implemented")
end

M.expand = function()
  -- local state = state.get()
  -- state.tree.expand(state.view.curline())
  error("not implemented")
end

M.collapse = function()
  -- local state = state.get()
  -- state.tree.collapse(state.view.curline())
  error("not implemented")
end

M.locate = function()
  -- local state = state.get()
  -- state.tree:setexpanded(fname())
  -- state.view.show()
  -- state.tree:load()
  error("not implemented")
end

M.open = function()
  -- local state = state.get()
  -- state.view.close()
  -- open(state.tree:getpath(state.view.curline())
  error("not implemented")
end

M.trash = function()
  -- local state = state.get()
  -- state.tree:trash(state.view.curline())
  error("not implemented")
end

M.rename = function()
  -- local state = state.get()
  -- state.tree:rename(state.view:curline(), state.view:input("rename to: "))
  error("not implemented")
end

M.mkdir = function()
  -- local state = state.get()
  -- state.tree:mkdir(state.view:curline(), state.view:input("directory name: "))
  error("not implemented")
end

M.mkfile = function()
  -- local state = state.get()
  -- state.tree:mkdir(state.view:curline(), state.view:input("file name: "))
  error("not implemented")
end

M.yank = function()
  -- local state = state.get()
  -- yank(state.entries[state.view:curline()])
  error("not implemented")
end

M.refresh = function()
  -- state.get().tree:reload()
  error("not implemented")
end

M.expandall =function()
  -- state.get().tree:expandall()
  error("not implemented")
end

M.collapseall = function()
  -- state.get().tree:collapseall()
  error("not implemented")
end

return M
