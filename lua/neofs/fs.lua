--- File System functionj
---
local const = require("neofs.const")
local os = require("os")

local fmt = string.format
local uv = vim.loop

local TYPES = {
  directory = const.TYPE_DIR,
  file      = const.TYPE_FILE,
  link      = const.TYPE_LINK,
}

function basename(str)
  return string.gsub(str, "(.*/)(.*)", "%2")
end

local function trim(str)
  return  string.gsub(str, "(/+)$", "")
end

local function join(parent, child)
  return fmt("%s%s%s", trim(parent), const.SEPARATOR, trim(child))
end

local function exists(path)
  return uv.fs_stat(path) ~= nil
end

local function entry(name, type, level, path)
  local stat, err = uv.fs_stat(path)
  if not stat then
    error(fmt("failed to stat %s: ", path) .. err)
  end

  local value = {
    name  = name,
    path  = path,
    type  = type,
    level = level,
    mode  = stat.mode,
    flags = stat.flags,
    size  = stat.size,
    atime = stat.atime.sec,
    ctime = stat.ctime.sec,
    mtime = stat.mtime.sec,
  }

  if type == const.TYPE_DIR then
    value.children = {}
  end

  return value
end

local function sort(entries, cmp)
  table.sort(entries, cmp)
  for i, e in ipairs(entries) do
    if e.children then
      sort(e.children, cmp)
    end
  end
end

local M = {}

M.join = join

M.exists = exists

M.dirname = vim.fs.dirname

M.scandir = function(level, root, expanded, filter, order)
  local entries = { entry(basename(root), const.TYPE_DIR, level, root) }

  local stack = { entries[1] }
  while #stack > 0 do
    local parent = table.remove(stack, #stack)

    local fd = uv.fs_scandir(parent.path)
    while fd do
      local name, uv_type = uv.fs_scandir_next(fd)
      if not name then
        break
      end

      local type = TYPES[uv_type]
      if not type then
        error("unexpected directory entry type " .. uv_type)
      end

      local path = join(parent.path, name)

      if not filter(name) then
        local e = entry(name, type, parent.level + 1, path)
        if type == const.TYPE_DIR and expanded[path] then
          table.insert(stack, e)
        end
        table.insert(parent.children, e)
      end
    end
  end

  sort(entries, order)
  return entries
end

M.trash = function(cmd, path)
  if not cmd then
    error("trash cmd is not configured")
  end
  if not vim.fn.executable(cmd) then
    error(fmt("%s is not executable", cmd))
  end
  local ok, _, rc = os.execute(fmt("%s %s 2> /dev/null", cmd, path))
  if not ok then
    error(fmt("%s returned %d", cmd, rc))
  end
end

M.mkdir = function(path)
  local ok, err = uv.fs_mkdir(path, 493)
  if not ok then
    error(err)
  end
  return path
end

M.create = function(path)
  local _, fd, err, code = pcall(uv.fs_open, path, "w", 420)
  if not fd then
    error(err, code)
  end
  uv.fs_close(fd)
  return path
end

M.rename = function(src, dst)
  local ok, err = uv.fs_rename(src, dst)
  if not ok then
    error(err)
  end
  return dst
end

return M
