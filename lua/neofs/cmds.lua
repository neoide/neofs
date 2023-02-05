--- Plugin commands
---
local conf = require("neofs.conf")
local const = require("neofs.conf")
local tree = require("neofs.tree")
local view = require("neofs.view")

local M = {}

M.show = function()
  -- local state = tree.get(view.getwinid())
  -- state.entries = fs.scandir(vim.fn.getcwd(), state.expanded, conf.fs)
  -- view.show(state, conf.view)
  error("not implemented")
end

M.close = function()
  -- view:close()
  error("not implemented")
end

M.expand = function()
  -- local state = tree.get(view.getwinid())
  -- local curline = view:curline()
  -- local curentry = state.entries[curline]
  -- if curentry.type ~= const.TYPE_DIR then
  --   return
  -- end
  -- local children = fs.scandir(fs.join(curentry.path, state.expanded, conf.fs)
  -- state.expand(curline, children)
  -- view:expand(line, curentry, children)
  error("not implemented")
end

M.collapse = function()
  -- local state = tree.get(view.getwinid())
  -- local curline = view:curline()
  -- local curentry = state.entries[curline]
  -- if curentry.type ~= const.TYPE_DIR then
  --   return
  -- end
  -- local nchildren = state.collapse(curline)
  -- view:collapse(curline, curentry, nchildren)
  error("not implemented")
end

M.locate = function()
  -- local neofs = state.get(view.getwinid())
  error("not implemented")
end

M.open = function()
  error("not implemented")
end

M.trash = function()
  error("not implemented")
end

M.rename = function()
  error("not implemented")
end

M.mkdir = function()
  error("not implemented")
end

M.mkfile = function()
  error("not implemented")
end

M.yank = function()
  error("not implemented")
end

M.move = function()
  error("not implemented")
end

return M
