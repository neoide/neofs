--- NeoFS plugin entry point
---
local cmds = require("neofs.cmds")
local conf = require("neofs.conf")

local function fail(...)
  error("configuration can be updated only once in function neofs.setup")
end

local function tbl_mkro(tab)
  for k, v in pairs(tab) do
    if type(v) == "table" then
      tab[k] = tbl_mkro(v)
    end
  end
  local proxy = {}
  setmetatable(proxy, {
    __index    = tab,
    __newindex = fail,
  })
  return proxy
end

local function tbl_merge(dst, src)
  for k, v in pairs(vim.tbl_deep_extend("force", dst, src)) do
    dst[k] = v
  end
end

local function init()
  vim.api.nvim_create_user_command("NeoFSShow", cmds.show, {})
  vim.api.nvim_create_user_command("NeoFSClose", cmds.close, {})
  vim.api.nvim_create_user_command("NeoFSLocate", cmds.locate, {})
  vim.api.nvim_create_user_command("NeoFSExpand", cmds.expand, {})
  vim.api.nvim_create_user_command("NeoFSCollapse", cmds.collapse, {})
  vim.api.nvim_create_user_command("NeoFSOpen", cmds.open, {})
  vim.api.nvim_create_user_command("NeoFSTrash", cmds.trash, {})
  vim.api.nvim_create_user_command("NeoFSRename", cmds.rename, {})
  vim.api.nvim_create_user_command("NeoFSMkdir", cmds.mkdir, {})
  vim.api.nvim_create_user_command("NeoFSMkfile", cmds.mkfile, {})
  vim.api.nvim_create_user_command("NeoFSYank", cmds.yank, {})
end

local function setup(usrcfg)
  tbl_merge(conf, usrcfg)
  tbl_mkro(conf)
  init()
end

return {
  setup = setup,
}
