local math = require("math")
local conf = require("neofs.conf")
local const = require("neofs.const")

-- { lines, highlights, signs }
local default_renderer = function(line, columns, entry)
  return entry.name
end

local View = {}
View.__index = View

function View:new(cwd, render)
  local obj = {
    cwd = cwd,
    columns = {},
    renderer = renderer or default_renderer,
  }
  return setmetatable(obj, View)
end

function View:curline()
  return vim.api.nvim_win_get_cursor(self:bufnr())[1]
end

function View:input(text)
  return vim.fn.input(text)
end

function View:error(message)
  vim.api.nvim_echo({ { const.ERR_PREFIX .. message } }, true)
end

function View:render(entries, root, len)
  local lines = {}
  for i = root, root + len - 1 do
    lines[i - root + 1] = self.renderer(i, self.columns, entries[i])
  end
  return lines
end

function View:show()
  local bufnum = vim.api.nvim_create_buf(false, false)
  -- vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_option(bufnum, "swapfile", false)
  vim.api.nvim_buf_set_option(bufnum, "buftype", "nofile")
  vim.api.nvim_buf_set_option(bufnum, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnum, "filetype", const.FILETYPE)
  -- TODO: render header properly
  vim.api.nvim_buf_set_lines(bufnum, 0, 0, true, { self.cwd })
  self.bufnum = bufnum
end

function View:close()
  vim.api.nvim_buf_delete(self:bufnr())
end

function View:onresized(entries)
  -- TODO: recalculate columns
  -- TODO: set header
  -- TODO: self:onexpanded(entries, 1, #entries)
end

function View:onchanged(entries, root, len)
  local bufnum = self.bufnum
  local buflen = vim.api.nvim_buf_line_count(bufnum)
  local lines = self:render(entries, root, len)
  vim.api.nvim_buf_set_lines(bufnum, root, math.min(len, buflen), true, lines)
  -- TODO: nvim_buf_add_highlight
end

function View:onexpanded(entries, root, len)
  local bufnum = self.bufnum
  local lines = self:render(entries, root, len)
  vim.api.nvim_buf_set_lines(bufnum, root, root + 1, true, lines)
  -- TODO: nvim_buf_add_highlight
end

function View:oncollapsed(entries, root, len)
  -- TODO: nvim_buf_clear_namespace
  local bufnum = self.bufnum
  local lines = self:render(entries, root, 1)
  vim.api.nvim_buf_set_lines(bufnum, root, root + len, true, lines)
  -- TODO: nvim_buf_add_highlight
end

return { new = View.new, render = render }
