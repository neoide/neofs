--- Global plugin configuration
---
local const = require("neofs.const")

local PRIO = {
  [const.TYPE_DIR]  = 1,
  [const.TYPE_FILE] = 2,
  [const.TYPE_LINK] = 2,
}

local function order(a, b)
  if a.level == b.level then
    local pa = PRIO[a.type]
    local pb = PRIO[b.type]
    return pa < pb or pa == pb and a.path < b.path
  end
  return a.path < b.path
end

local function filter(...)
  return true
end

return {
  cmd = {
    git   = "git",
    trash = "trash",
  },
  tree = {
    order  = order,
    filter = filter,
  },
  view = {
    dir_opened_icon = "",
    dir_closed_icon = "",
    -- dir_opened_icon = "▼",
    -- dir_closed_icon = "▶",
    indent_sign = "│",
    last_indent_sign = "└",
    columns = {
      left  = { "name" },
      right = { "owner", "group", "mode", "mtime", "size" },
    }
  },
}
