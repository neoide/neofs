local path = require("pl.path")
local conf = require("neofs.conf")
local const = require("neofs.const")
local fs = require("neofs.fs")

describe("fs.scandir #fs.scandir", function()
  local fstree = {
    a = {
      a = {
        x = {},
        y = {
          ".z.txt",
          "x.txt",
          "y.js",
        },
        "a.md",
      },
      b = {},
      c = {
        "x.js",
        "y.js",
      },
      "a.txt",
      "b.txt",
    },
    b = {},
    c = {
      "f1.c",
      "f2.c",
    },
    ".x",
    ".y",
    "a.txt",
    "b.rst",
  }

  before_each(function()
    utils.mkfs(utils.NEWCWD, fstree)
  end)

  after_each(function()
    utils.rmfs(utils.NEWCWD)
  end)

  local filter = conf.tree.filter
  local order = conf.tree.order

  local function read(entry)
    local value = { name = entry.name, type = entry.type, level = entry.level }
    if entry.children then
      value.children = vim.tbl_map(read, entry.children)
    end
    return value
  end

  it("reads empty tree as empty table", function()
    local root = path.join(utils.NEWCWD, "b")
    local entries = fs.scandir(const.ROOT_LEVEL, root, {}, filter, order)
    local actual = vim.tbl_map(read, entries)

    local expected = {
      {
        level     = 0,
        type      = 1,
        name      = "b",
        children  = {},
      },
    }

    assert.are.same(expected, actual)
  end)

  it("reads tree without expand", function()
    local entries = fs.scandir(const.ROOT_LEVEL, utils.NEWCWD, {}, filter, order)
    local actual = vim.tbl_map(read, entries)

    local expected = {
      {
        level = 0,
        type  = 1,
        name  = "neofs",
        children = {
          {
            level = 1,
            name = "a",
            type = 1,
            children = {},
          },
          {
            level = 1,
            name = "b",
            type = 1,
            children = {},
          },
          {
            level = 1,
            name = "c",
            type = 1,
            children = {},
          },
          {
            level = 1,
            name = ".x",
            type = 2,
          },
          {
            level = 1,
            name = ".y",
            type = 2,
          },
          {
            level = 1,
            name = "a.txt",
            type = 2,
          },
          {
            level = 1,
            name = "b.rst",
            type = 2,
          },
        },
      },
    }

    assert.are.same(expected, actual)
  end)

  it("reads tree with expand", function()
    local expanded = {
      [path.join(utils.NEWCWD, "a")] = true,
      [path.join(utils.NEWCWD, "a/c")] = true,
      [path.join(utils.NEWCWD, "b")] = true,
      [path.join(utils.NEWCWD, "c")] = true,
    }

    local entries = fs.scandir(const.ROOT_LEVEL, utils.NEWCWD, expanded, filter, order)
    local actual = vim.tbl_map(read, entries)

    local expected = {
      {
        children = {
          {
            children = {
              {
                children = {},
                level = 2,
                name = "a",
                type = 1
              },
              {
                children = {},
                level = 2,
                name = "b",
                type = 1
              },
              {
                children = {
                  {
                    level = 3,
                    name = "x.js",
                    type = 2
                  },
                  {
                    level = 3,
                    name = "y.js",
                    type = 2
                  },
                },
                level = 2,
                name = "c",
                type = 1
              },
              {
                level = 2,
                name = "a.txt",
                type = 2
              },
              {
                level = 2,
                name = "b.txt",
                type = 2
              },
            },
            level = 1,
            name = "a",
            type = 1
          },
          {
            children = {},
            level = 1,
            name = "b",
            type = 1
          },
          {
            children = {
              {
                level = 2,
                name = "f1.c",
                type = 2
              },
              {
                level = 2,
                name = "f2.c",
                type = 2
              },
            },
            level = 1,
            name = "c",
            type = 1
          },
          {
            level = 1,
            name = ".x",
            type = 2
          },
          {
            level = 1,
            name = ".y",
            type = 2
          },
          {
            level = 1,
            name = "a.txt",
            type = 2
          },
          {
            level = 1,
            name = "b.rst",
            type = 2
          },
        },
        level = 0,
        name = "neofs",
        type = 1
      },
    }

    assert.are.same(expected, actual)
  end)
end)

describe("mkdir #fs.mkdir", function()
  before_each(function()
    os.execute("mkdir -p " .. path.join(utils.NEWCWD, "dir_1"))
  end)

  after_each(function()
    os.execute("rm -rf " .. path.join(utils.NEWCWD, "dir_1"))
  end)

  it("creates new directory if parent exists", function()
    local dirpath = path.join(utils.NEWCWD, "dir_1/dir_1_1")
    fs.mkdir(dirpath)
    assert.is.truthy(path.exists(dirpath))
  end)

  it("fails if parent directory does not exists", function()
    local dirpath = path.join(utils.NEWCWD, "dir_2/dir_2_1")
    assert.has.errors(function()
      fs.mkdir(dirpath)
    end)
    assert.is.falsy(path.exists(dirpath))
  end)
end)

describe("create #fs.create", function()
  before_each(function()
    os.execute("mkdir -p " .. path.join(utils.NEWCWD, "dir_1"))
  end)

  after_each(function()
    os.execute("rm -rf " .. path.join(utils.NEWCWD, "dir_1"))
  end)

  it("creates file if parent directory exists", function()
    local filepath = path.join(utils.NEWCWD, "dir_1/test.txt")
    fs.create(filepath)
    assert.is.truthy(path.exists(filepath))
  end)

  it("faild if parent directory does not exist", function()
    local filepath = path.join(utils.NEWCWD, "dir_2/test.txt")
    assert.has.errors(function()
      fs.create(filepath)
    end)
    assert.is.falsy(path.exists(filepath))
  end)
end)

describe("rename #fs.rename", function()
  before_each(function()
    os.execute("mkdir -p " .. path.join(utils.NEWCWD, "root/dir_1"))
    os.execute("mkdir -p " .. path.join(utils.NEWCWD, "root/dir_2"))
    os.execute("touch " .. path.join(utils.NEWCWD, "root/dir_1/file_1"))
  end)

  after_each(function()
    os.execute("rm -rf " .. path.join(utils.NEWCWD, "root"))
  end)

  it("renames if file exists", function()
    local src = path.join(utils.NEWCWD, "root/dir_1/file_1")
    local dst = path.join(utils.NEWCWD, "root/dir_2/file_1")
    fs.rename(src, dst)
    assert.is.falsy(path.exists(src))
    assert.is.truthy(path.exists(dst))
  end)

  it("fails if source does not exist", function()
    local src = path.join(utils.NEWCWD, "root/dir_X/file_1")
    local dst = path.join(utils.NEWCWD, "root/dir_2/file_1")
    assert.has.errors(function()
      fs.rename(src, dst)
    end)
    assert.is.falsy(path.exists(src))
    assert.is.falsy(path.exists(dst))
  end)

  it("fails if target does not exist", function()
    local src = path.join(utils.NEWCWD, "root/dir_1/file_1")
    local dst = path.join(utils.NEWCWD, "root/dir_X/file_1")
    assert.has.errors(function()
      fs.rename(src, dst)
    end)
    assert.is.truthy(path.exists(src))
    assert.is.falsy(path.exists(dst))
  end)
end)

describe("trash #fs.trash", function()
  local trashcmd = "trash"

  before_each(function()
    os.execute("mkdir -p " .. path.join(utils.NEWCWD, "dir_1"))
  end)

  after_each(function()
    os.execute("rm -rf " .. path.join(utils.NEWCWD, "dir_1"))
  end)

  it("executes trashcmd if path exists", function()
    local dirpath = path.join(utils.NEWCWD, "dir_1")
    fs.trash(trashcmd, dirpath)
    assert.is.falsy(path.exists(dirpath))
  end)

  it("fails if trash cmd not in path", function()
    assert.has.errors(function()
      fs.trash("xxx", path.join(utils.NEWCWD, "dir_1"))
    end)
  end)

  it("fails if path does not exist", function()
    assert.has.errors(function()
      fs.trash(trashcmd, path.join(utils.NEWCWD, "dir_X"))
    end)
  end)
end)
