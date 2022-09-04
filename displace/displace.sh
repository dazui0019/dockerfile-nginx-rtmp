#!/bin/bash

# 获取计算机芯片架构
ARCH=`arch`
if [ ${ARCH} == "aarch64" ]
then
    mv /etc/apt/sources.list /etc/apt/sources.list.back
    cp displace/arm-sources.list /etc/apt/sources.list
elif [ ${ARCH} == "x86_64" ]
then
    mv /etc/apt/sources.list /etc/apt/sources.list.back
    cp displace/x86_64-sources.list /etc/apt/sources.list
else
    echo ${ARCH}
fi
