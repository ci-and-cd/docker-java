#!/bin/sh

#if [ -z "${build_fileserver}" ]; then build_fileserver="https://github.com"; fi
if [ -z "${build_fileserver}" ]; then build_fileserver="http://o9wbz99tz.bkt.clouddn.com"; fi
  ${ARIA2C_DOWNLOAD} -d /usr/bin -o waitforit "${build_fileserver}/maxcnunes/waitforit/releases/download/v2.2.0/waitforit-linux_amd64" \
    && chmod 755 /usr/bin/waitforit
