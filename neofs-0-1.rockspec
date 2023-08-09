package = "neofs"
version = "0-1"
rockspec_format = "3.0"

source = {
  url = "https://github.com/vbogretsov/neofs",
}

dependencies = {
  "lua == 5.1",
  "busted",
  "penlight",
  "lyaml",
  "luacov",
}

build = {
  type = "builtin",
  copy_directories = {
    "doc",
    "lua",
  }
}

test = {
  type = "command",
  command = "nvim",
  flags = {
    "--headless",
    "--noplugin",
    "-u", "init.lua",
    "-c", "lua require 'runtest'",
  }
}
