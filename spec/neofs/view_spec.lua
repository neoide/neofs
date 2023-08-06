local const = require("neofs.const")
local view = require("neofs.view")

describe("neofs.view", function()
  before_each(function()
  end)

  after_each(function()
  end)

  describe("onchanged", function()
    local v = view:new("/root")
    v:show()

    local entries = {
      { name = "dir-1", path = "/root/dir-1", level = 0, type = const.TYPE_DIR },
      { name = "dir-2", path = "/root/dir-2", level = 0, type = const.TYPE_DIR },
      { name = "dir-3", path = "/root/dir-3", level = 0, type = const.TYPE_DIR },
      { name = "file-1", path = "/root/file-1", level = 0, type = const.TYPE_FILE },
      { name = "file-2", path = "/root/file-2", level = 0, type = const.TYPE_FILE },
      { name = "file-3", path = "/root/file-2", level = 0, type = const.TYPE_FILE },
    }

    v:onchanged(entries, 1, #entries)
    -- local lines = vim.api.nvim_buf_get_lines(v.bufnum, 0, -1, true)
    -- print(vim.inspect(lines))
  end)

  describe("experiment", function()
    local v = view:new("/root")
    v:show()

    local entries = {
      { name = "dir-1", path = "/root/dir-1", level = 0, type = const.TYPE_DIR },
      { name = "dir-2", path = "/root/dir-2", level = 0, type = const.TYPE_DIR },
      { name = "dir-3", path = "/root/dir-3", level = 0, type = const.TYPE_DIR },
      { name = "file-1", path = "/root/file-1", level = 0, type = const.TYPE_FILE },
      { name = "file-2", path = "/root/file-2", level = 0, type = const.TYPE_FILE },
      { name = "file-3", path = "/root/file-2", level = 0, type = const.TYPE_FILE },
    }

    v:onchanged(entries, 1, #entries)
    local entries = {
      { name = "dir-1", path = "/root/dir-1", level = 0, type = const.TYPE_DIR },
      { name = "- dir-2", path = "/root/dir-2", level = 0, type = const.TYPE_DIR },
      { name = "dir-2-1", path = "/root/dir-2/dir-2-1", level = 0, type = const.TYPE_DIR },
      { name = "dir-2-2", path = "/root/dir-2/dir-2-2", level = 0, type = const.TYPE_DIR },
      { name = "file-2-1", path = "/root/dir-2/file-2-1", level = 0, type = const.TYPE_FILE },
      { name = "file-2-2", path = "/root/dir-2/file-2-2", level = 0, type = const.TYPE_FILE },
      { name = "dir-3", path = "/root/dir-3", level = 0, type = const.TYPE_DIR },
      { name = "file-1", path = "/root/file-1", level = 0, type = const.TYPE_FILE },
      { name = "file-2", path = "/root/file-2", level = 0, type = const.TYPE_FILE },
      { name = "file-3", path = "/root/file-2", level = 0, type = const.TYPE_FILE },
    }
    v:onexpanded(entries, 2, 5)
    local lines = vim.api.nvim_buf_get_lines(v.bufnum, 0, -1, true)
    print(vim.inspect(lines))

    local entries = {
      { name = "dir-1", path = "/root/dir-1", level = 0, type = const.TYPE_DIR },
      { name = "- dir-2", path = "/root/dir-2", level = 0, type = const.TYPE_DIR },
      { name = "dir-2-1", path = "/root/dir-2/dir-2-1", level = 0, type = const.TYPE_DIR },
      { name = "dir-2-2", path = "/root/dir-2/dir-2-2", level = 0, type = const.TYPE_DIR },
      { name = "file-2-1", path = "/root/dir-2/file-2-1", level = 0, type = const.TYPE_FILE },
      { name = "file-2-2", path = "/root/dir-2/file-2-2", level = 0, type = const.TYPE_FILE },
      { name = "dir-3", path = "/root/dir-3", level = 0, type = const.TYPE_DIR },
      { name = "file-1", path = "/root/file-1", level = 0, type = const.TYPE_FILE },
      { name = "file-2", path = "/root/file-2", level = 0, type = const.TYPE_FILE },
      { name = "file-3", path = "/root/file-2", level = 0, type = const.TYPE_FILE },
    }


  end)
end)
