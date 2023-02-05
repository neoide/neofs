return {
  expanded = {
    ["/tmp/neofs/dir_1"] = true,
    ["/tmp/neofs/dir1_1"] = true,
    ["/tmp/neofs/dir_1/dir_1_1/dir_1_1_1"] = true,
    ["/tmp/neofs/dir_1/dir_1_2"] = true,
    ["/tmp/neofs/dir_2"] = true,
    ["/tmp/neofs/dir_4"] = true,
  },
  expected = {
    {
      level = 0,
      name = "dir_1",
      type = 1
    },
    {
      level = 1,
      name = "dir_1_1",
      type = 1
    },
    {
      level = 2,
      name = "dir_1_1_1",
      type = 1
    },
    {
      level = 2,
      name = "afile_1_1_1",
      type = 2
    },
    {
      level = 2,
      name = "bfile_1_1_2",
      type = 2
    },
    {
      level = 3,
      name = "file_1_1_1_1",
      type = 2
    },
    {
      level = 3,
      name = "file_1_1_1_2",
      type = 2
    },
    {
      level = 2,
      name = "zfile_1_1_3",
      type = 2
    },
    {
      level = 1,
      name = "dir_1_2",
      type = 1
    },
    {
      level = 2,
      name = "file_1_2_1",
      type = 2
    },
    {
      level = 2,
      name = "file_1_2_2",
      type = 2
    },
    {
      level = 2,
      name = "file_1_2_3",
      type = 2
    },
    {
      level = 0,
      name = "dir_2",
      type = 1
    },
    {
      level = 1,
      name = "dir_2_1",
      type = 1
    },
    {
      level = 1,
      name = "dir_2_2",
      type = 1
    },
    {
      level = 1,
      name = "dir_4_1",
      type = 1
    },
    {
      level = 1,
      name = "dir_4_2",
      type = 1
    },
    {
      level = 1,
      name = "file_1",
      type = 2
    },
    {
      level = 1,
      name = "file_2",
      type = 2
    },
    {
      level = 1,
      name = "file_3",
      type = 2
    },
    {
      level = 1,
      name = "file_4",
      type = 2
    },
    {
      level = 1,
      name = "file_5",
      type = 2
    },
    {
      level = 0,
      name = "dir_3",
      type = 1
    },
    {
      level = 0,
      name = "dir_4",
      type = 1
    },
    {
      level = 1,
      name = "file_1",
      type = 2
    },
    {
      level = 1,
      name = "file_2",
      type = 2
    },
    {
      level = 1,
      name = "file_3",
      type = 2
    },
    {
      level = 1,
      name = "file_4",
      type = 2
    },
    {
      level = 1,
      name = "file_5",
      type = 2
    },
    {
      level = 1,
      name = "file_6",
      type = 2
    },
    {
      level = 0,
      name = "file_1",
      type = 2
    },
    {
      level = 0,
      name = "file_2",
      type = 2
    },
    {
      level = 0,
      name = "file_3",
      type = 2
    },
    {
      level = 0,
      name = "file_4",
      type = 2
    },
    {
      level = 0,
      name = "file_5",
      type = 2
    },
    {
      level = 0,
      name = "file_6",
      type = 2
    },
    {
      level = 0,
      name = "file_7",
      type = 2
    },
  },
}
