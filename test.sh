#!/bin/sh

nvim \
    --headless \
    --noplugin \
    -u \
    spec/init.lua \
    -c \
    'lua require("test")'
