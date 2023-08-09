describe("neofs setup", function()
  it("overrides configuration", function()
    local plugin_conf = require("neofs.conf")
    local user_conf = {
      view = {
        dir_open_icon  = "-",
        dir_close_icon = "+",
      },
      test = {
        x = 1,
      },
    }
    local expected_conf = vim.tbl_deep_extend("force", plugin_conf, user_conf)
    require("neofs").setup(user_conf)
    assert.are.same(plugin_conf, expected_conf)
  end)

  it("makes configuration readonly", function()
    assert.has.errors(function()
      local conf = require("neofs.conf")
      conf.view.dir_open_icon = "X"
    end)
  end)
end)
