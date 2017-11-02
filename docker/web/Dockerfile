FROM elixir:1.5.2
MAINTAINER soar <85624529@qq.com>

RUN sudo apt-get update && sudo apt-get install -y wget

RUN mix local.hex --force && mix local.rebar --force

# add node 8.8.0
# gpg keys listed at https://github.com/nodejs/node#release-team

RUN wget https://npm.taobao.org/mirrors/node/latest-v8.x/node-v8.9.0-linux-x64.tar.xz && \
    tar -C /usr/local --strip-components 1 -xzf node-v8.9.0-linux-x64.tar.xz && \
    rm node-v8.9.0-linux-x64.tar.xz
RUN npm install --production -d --registry=https://registry.npm.taobao.org
WORKDIR /data/www/vr
