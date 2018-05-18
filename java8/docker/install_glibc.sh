#!/bin/sh

#if [ -z "${build_fileserver}" ]; then build_fileserver="https://github.com"; fi
if [ -z "${build_fileserver}" ]; then build_fileserver="http://o9wbz99tz.bkt.clouddn.com"; fi
curl -Ls ${build_fileserver}/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk > /tmp/glibc-2.23-r3.apk \
    && apk add --allow-untrusted /tmp/glibc-2.23-r3.apk
