FROM alpine:3.18

RUN apk add \
    gcc \
    make \
    musl-dev \
    lua-dev \
    luarocks \
    neovim \
    trash-cli

RUN adduser -D neofs

COPY neofs-0-1.rockspec /tmp/neofs-0-1.rockspec
RUN luarocks-5.1 install --only-deps /tmp/neofs-0-1.rockspec

WORKDIR /home/neofs
USER neofs
