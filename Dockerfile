FROM alpine:3.18

RUN apk add \
    gcc \
    tree \
    make \
    musl-dev \
    lua-dev \
    luarocks \
    neovim \
    trash-cli \
    yaml-dev \
    git

RUN adduser -D neofs
RUN ln -s /usr/bin/luarocks-5.1 /usr/bin/luarocks

COPY neofs-0-1.rockspec /tmp/neofs-0-1.rockspec
RUN luarocks install --only-deps /tmp/neofs-0-1.rockspec

WORKDIR /home/neofs
USER neofs
