#!/bin/sh

if [ -z "${build_fileserver}" ]; then build_fileserver="https://github.com"; fi
curl -Ls ${build_fileserver}/sgerrand/alpine-pkg-glibc/releases/download/2.23-r3/glibc-2.23-r3.apk > /tmp/glibc-2.23-r3.apk && \
    apk add --allow-untrusted /tmp/glibc-2.23-r3.apk
