package = "neofs"
version = "0-1"

source = {
  url = "https://github.com/vbogretsov/neofs",
}

dependencies = {
  "lua == 5.1",
  "busted",
  "penlight",
}

build = {
  type = "builtin",
  copy_directories = {
    "doc",
    "lua",
  }
}
