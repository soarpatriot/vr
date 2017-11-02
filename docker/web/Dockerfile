FROM elixir:1.5.2
MAINTAINER soar <85624529@qq.com>

RUN apt-get update && apt-get install -y wget

RUN mix local.hex --force && mix local.rebar --force

# add node 8.8.0
# gpg keys listed at https://github.com/nodejs/node#release-team

RUN wget https://npm.taobao.org/mirrors/node/latest-v8.x/node-v8.9.0-linux-x64.tar.xz && \
    tar zxvf node-v8.9.0-linux-x64.tar.xz && \
    ln -s ～/node-v8.9.0-linux-x64/bin/node /usr/local/bin/node && \
    ln -s ～/node-v8.9.0-linux-x64/bin/node /usr/local/bin/npm && \
    rm node-v8.9.0-linux-x64.tar.xz

RUN npm install --production -d --registry=https://registry.npm.taobao.org

WORKDIR /data/www/vr
