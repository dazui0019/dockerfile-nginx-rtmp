FROM ubuntu:22.04

# MAINTAINER 指令已不推荐使用, 因此使用 LABEL
LABEL maintainer="dazui0019 <dazui0019@gmail.com>"

# 进入工作区
WORKDIR /tmp/

# 复制文件到容器
# 保留原来的目录结构
COPY html/ /tmp/html/
COPY displace/ /tmp/displace/

EXPOSE 80

RUN set -x \
# 换源以及安装依赖
    && chmod +x displace/displace.sh \
    && displace/displace.sh \
    && apt update \
    && buildDeps='libpcre3 libpcre3-dev zlib1g-dev tar openssl libssl-dev gcc make git wget' \
    && apt install -y ${buildDeps}\
# 编译nginx
    && mkdir nginx/ \
    && cd nginx/ \
    && git clone https://github.com/arut/nginx-rtmp-module.git \
    && wget https://nginx.org/download/nginx-1.22.0.tar.gz -O nginx-1.22.0.tar.gz \
    && tar -xaf nginx-1.22.0.tar.gz \
    && cd nginx-1.22.0/ \
    && ./configure --add-module=../nginx-rtmp-module/ \
    && make \
    && make install \
# 清理空间
    && mv /etc/apt/sources.list.back /etc/apt/sources.list \
    && apt-get remove gcc make git wget --purge --auto-remove -y && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

STOPSIGNAL SIGQUIT
CMD ["nginx", "-g", "daemon off;"]
