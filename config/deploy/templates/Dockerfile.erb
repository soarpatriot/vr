FROM elixir:1.5.2
MAINTAINER soar <85624529@qq.com>

ENV HEX_MIRROR=https://hexpm.upyun.com HEX_CDN=https://hexpm.upyun.com
RUN apt-get update && apt-get install -y wget

# add node 8.8.0
# gpg keys listed at https://github.com/nodejs/node#release-team
WORKDIR /soft
RUN wget https://npm.taobao.org/mirrors/node/latest-v8.x/node-v8.9.0-linux-x64.tar.xz &&\
    tar xvJf node-v8.9.0-linux-x64.tar.xz && \
    ln -s /soft/node-v8.9.0-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /soft/node-v8.9.0-linux-x64/bin/npm /usr/local/bin/npm && \
    chmod +x /soft/node-v8.9.0-linux-x64/bin/npm &&\
    rm node-v8.9.0-linux-x64.tar.xz

RUN npm install --production -d --registry=https://registry.npm.taobao.org

WORKDIR /data/www/vr
