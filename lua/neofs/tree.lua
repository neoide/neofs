--- Plugin state persistence
---
local string = require("string")
local fs = require("neofs.fs")
local conf = require("neofs.conf")

local Tree = {}
Tree.__index = Tree

function Tree:new(cwd)
  local default = {
    cwd = cwd,

    entries  = {},
    expanded = {},

    event = {
      onchanged = function(...)
      end,

      onexpanded = function(...)
      end,

      oncollapsed = function(...)
      end,
    }
  }
  return setmetatable(default, Tree)
end

function Tree:scandir(level, dir)
  -- TODO: add git status results
  return fs.scandir(level, dir, self.expanded, conf.tree.filter)
end

function Tree:load(root)
  if root == 0 then
    self.entries = self:scandir(0, cwd)
    self.event.onchanged(self.entries, 1, #self.entries)
    return
  end

  if root < 0 or root > #self.entries then
    error(string.format("reload failed: index out of range %d", root))
  end

  local oldnumchildren = self:numchildren(root)
  local dir = self.entries[root]

  local children = self:scandir(dir.level, dir.path)

  local entries = {}
  for i = 1, root do
    entries[i] = self.entries[i]
  end

  for i = root + 1, root + #children do
    entries[i] = children[i - root]
  end

  for i = root + numchildren + 1, #self.entries do
    entries[i] = self.entries[i]
  end

  self.entries = entries
  self.event.onchanged(self.entries, root, #children, oldnumchildren + 1)
end

--- (int, list[entry) -> void
function Tree:expand(index)
  if index < 1 or index > #self.entries then
    error(string.format("expand failed: index out of range %d", index))
  end

  local entry = self.entries[index]

  if entry.type ~= const.TYPE_DIR then
    return
  end

  self.expanded[entry.path] = true
  local children = self:scandir(0, entry.path)

  local entries = {}
  for i = 1, index do
    entries[i] = self.entries[i]
  end

  for i = 1, #children do
    entries[index + i] = children[i]
  end

  for i = index + 1, #self.entries do
    entries[#entries + 1] = self.entries[i]
  end

  self.entries = entries
  self.event.onexpanded(self.entries, index, #children + 1)
end

--- (int) -> int
function Tree:collapse(index)
  if index < 1 or index > #self.entries then
    error(string.format("collapse failed: index out of range %d", index))
  end

  local entry = self.entries[index]

  if entry.type ~= const.TYPE_DIR then
    return
  end

  self.expanded[entry.path] = nil

  local entries = {}
  for i = 1, index do
    entries[i] = self.entries[i]
  end

  local level = self.entries[index].level

  local collapsed = 0
  for i = index + 1, #self.entries do
    if self.entries[i].level <= level then
      break
    end
    collapsed = collapsed + 1
  end

  for i = index + 1 + collapsed, #self.entries do
    entries[#entries + 1] = self.entries[i]
  end

  self.entries = entries
  self.event.oncollapsed(self.entries, index, collapsed + 1)
end

function Tree:numchildren(parent)
  -- TODO: make algorithm order independent
  if parent == 0 then
    return #entries
  end

  local level = self.entries[parent].level

  local result = 0
  for i = parent, #entries do
    if self.entries[i].level >= level then
      break
    end
    result = result + 1
  end
  return result
end

function Tree:parent(index)
  -- TODO: make algorithm order independent
  if index < 1 or index > #self.entries then
    error(string.format("parent failed: index out of range %d", index))
  end

  local entry = self.entries[index]
  if entry.level == 1 then
    return 0
  end

  local parent = index
  for i = index, 1, -1 do
    if self.entries[i].level < entry.level then
      parent = i
    end
  end
  return parent
end

function Tree:makepath(parent, name)
  local base = parent and self.entries[parent].path or self.cwd
  return fs.join(base, name)
end

function Tree:addfile(index, name)
  local parent = self:parent(index)
  fs.create(self:makepath(parent, name))
  self:load(parent)
end

function Tree:adddir(index, name)
  local parent = self:parent(index)
  fs.mkdir(self:makepath(parent, name))
  self:load(parent)
end

function Tree:rename(index, name)
  local parent = self:parent(index)
  fs.rename(self.entries[index].path, self:makepath(parent, name))
  self:load(parent)
end

function Tree:trash(index, name)
  local parent = self:parent(index)
  fs.trash(self:makepath(parent, name))
  self:load(parent)
end

return { Tree = Tree }
