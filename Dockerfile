FROM ubuntu:22.04

# MAINTAINER 指令已不推荐使用, 因此使用 LABEL
LABEL maintainer="dazui0019 <dazui0019@gmail.com>"

# 进入工作区
WORKDIR /tmp/

# 复制文件到容器
# 保留原来的目录结构
COPY html/ /tmp/html/
COPY replace/ /tmp/replace/
COPY nginx-rtmp-module/ /tmp/nginx/nginx-rtmp-module/
COPY nginx-1.22.0.tar.gz /tmp/nginx/nginx-1.22.0.tar.gz

# 配置 sources.list
RUN \
    apt update \
    && apt install -y apt-transport-https ca-certificates \
    && chmod +x replace/replace.sh \
    && replace/replace.sh \
    && apt update

# 安装依赖
RUN apt install -y \
    libpcre3 libpcre3-dev zlib1g-dev tar openssl libssl-dev autotools-dev autoconf build-essential git

# 编译nginx
RUN \
    cd nginx/ \
    && tar -xaf nginx-1.22.0.tar.gz \
    && cd nginx-1.22.0/ \
    && ./configure --add-module=../nginx-rtmp-module/ \
    && make \
    && make install \
    && cd /tmp/
