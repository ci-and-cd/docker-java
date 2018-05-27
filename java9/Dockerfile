# ${DOCKER_REGISTRY}/java:oracle-9.0.4-jdk-alpine
#
# The main caveat to note is that it does use musl libc instead of glibc and friends,
# so certain software might run into issues depending on the depth of their libc requirements.
# However, most software doesn't have an issue with this,
# so this variant is usually a very safe choice.
#
# see: https://github.com/sgerrand/alpine-pkg-glibc/issues/75
# see: https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/9/jdk/alpine/Dockerfile.openj9#L32
#
FROM alpine:3.7

#FROM alpine:3.7 as packager
# ...
#COPY --from=packager /Library/Java/JavaVirtualMachines/jdk-9.0.4.jdk/Contents/Home /Library/Java/JavaVirtualMachines/jdk-9.0.4.jdk/Contents/Home

MAINTAINER haolun

ARG build_fileserver
ENV ARIA2C_DOWNLOAD aria2c --file-allocation=none -c -x 10 -s 10 -m 0 --console-log-level=notice --log-level=notice --summary-interval=0
ENV JDK_HOME /Library/Java/JavaVirtualMachines/jdk-9.0.4.jdk/Contents/Home
ENV JAVA_HOME /Library/Java/JavaVirtualMachines/jdk-9.0.4.jre/Contents/Home

# see: http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase9-3934878.html
# http://download.oracle.com/otn/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz?AuthParam=${auth_param}
# jdk-9.0.4_linux-x64_bin.tar.gz sha256: 90c4ea877e816e3440862cfa36341bc87d05373d53389ec0f2d54d4e8c95daa2
#sha256sum -c /tmp/jdk-9.0.4_linux-x64_bin.tar.gz.sha256

RUN set -ex \
    && echo ===== Install tools ===== \
    && echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.7/main" > /etc/apk/repositories \
    && echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.7/community" >> /etc/apk/repositories \
    && echo "https://mirror.tuna.tsinghua.edu.cn/alpine/edge/testing/" >> /etc/apk/repositories \
    && apk add --update --upgrade apk-tools \
    && apk upgrade --update \
    && apk add aria2 bash binutils ca-certificates curl git libstdc++ openssh tar unzip wget xz \
    && echo ===== Set locale ===== \
    && apk add font-adobe-100dpi tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && apk del tzdata \
    && rm -rf /tmp/* /var/cache/apk/* \
    && echo "UTC+8:00" > /etc/TZ \
    && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh \
    && echo ===== Install waitforit ===== \
    && ${ARIA2C_DOWNLOAD} -d /usr/bin -o "waitforit" "http://o9wbz99tz.bkt.clouddn.com/maxcnunes/waitforit/releases/download/v2.2.0/waitforit-linux_amd64" \
    && chmod 755 /usr/bin/waitforit \
    && echo ===== Install glibc ===== \
    && GLIBC_VERSION="2.25-r0" \
    && ${ARIA2C_DOWNLOAD} -d /tmp -o "glibc-${GLIBC_VERSION}.apk" "http://o9wbz99tz.bkt.clouddn.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" \
    && apk add --allow-untrusted /tmp/glibc-${GLIBC_VERSION}.apk \
    && echo ===== Install JDK9 ===== \
    && cd /tmp \
    && ${ARIA2C_DOWNLOAD} --header="Cookie: oraclelicense=accept-securebackup-cookie" -d /tmp -o "jdk-9.0.4_linux-x64_bin.tar.gz" "http://o9wbz99tz.bkt.clouddn.com/otn/java/jdk/9.0.4+11/c2514751926b4512b076cc82f959763f/jdk-9.0.4_linux-x64_bin.tar.gz" \
    && tar -xzf jdk-9.0.4_linux-x64_bin.tar.gz \
    && mkdir -p $(dirname ${JDK_HOME}) \
    && mv /tmp/jdk-9.0.4 ${JDK_HOME} \
    && rm -f ${JDK_HOME}/lib/src.zip \
    && echo ===== Install archlinux gcc-libs  ===== \
    && echo "https://www.archlinux.org/packages/core/x86_64/gcc-libs/gcc-libs-7.3.1+20180406-1-x86_64.pkg.tar.xz" \
    && echo "http://archlinux.thaller.ws/core/os/x86_64/gcc-libs-7.3.1+20180406-1-x86_64.pkg.tar.xz" \
    && ${ARIA2C_DOWNLOAD} -d /tmp -o "gcc-libs.tar.xz" "http://o9wbz99tz.bkt.clouddn.com/core/os/x86_64/gcc-libs-7.3.1+20180406-1-x86_64.pkg.tar.xz" \
    && mkdir /tmp/gcc \
    && tar -xf /tmp/gcc-libs.tar.xz -C /tmp/gcc \
    && mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib \
    && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
    && apk del binutils \
    && echo ===== Install archlinux zlib  ===== \
    && echo "https://www.archlinux.org/packages/core/x86_64/zlib/download" \
    && echo "http://archlinux.thaller.ws/core/os/x86_64/zlib-1:1.2.11-2-x86_64.pkg.tar.xz" \
    && ${ARIA2C_DOWNLOAD} -d /tmp -o "zlib.tar.xz" "http://o9wbz99tz.bkt.clouddn.com/core/os/x86_64/zlib-1:1.2.11-2-x86_64.pkg.tar.xz" \
    && mkdir /tmp/zlib \
    && tar -xf /tmp/zlib.tar.xz -C /tmp/zlib \
    && mv /tmp/zlib/usr/lib/* /usr/glibc-compat/lib \
    && echo ===== Export jre  ===== \
    && cd $(dirname ${JDK_HOME}) \
    && ${JDK_HOME}/bin/jlink -p ${JDK_HOME}/jmods --add-modules java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument,java.rmi,java.xml.bind,java.xml.ws,java.xml.ws.annotation --output jre9-oracle \
    && mkdir -p $(dirname ${JAVA_HOME}) \
    && mv jre9-oracle ${JAVA_HOME} \
    && ln -s "${JAVA_HOME}/bin/"* "/usr/bin/" \
    && rm -rf ${JDK_HOME} \
    && rm -rf /tmp/* /var/cache/apk/*









#echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf

# Install agents
COPY docker/ejstatd-1.0.0.jar /opt/ejstatd/ejstatd-1.0.0.jar
# Need libstdc++.so.6 in libstdc++
# Could not find agent library /opt/jprofiler/bin/linux-x64/libjprofilerti.so in absolute path, with error: libstdc++.so.6: cannot open shared object file: No such file or directory
COPY docker/jprofiler/bin/linux-x64/libattach.so /opt/jprofiler/bin/linux-x64/libattach.so
COPY docker/jprofiler/bin/linux-x64/libjprofilerti.so /opt/jprofiler/bin/linux-x64/libjprofilerti.so
COPY docker/java_debug_monitor_profiler.sh /opt/java_debug_monitor_profiler.sh

# Set environment
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV PATH ${PATH}:${JAVA_HOME}/bin

# Do not use "/lib:/usr/lib:/usr/local/lib", java will crash
ENV LD_LIBRARY_PATH /usr/glibc-compat/lib

ENV JAVA_OPTS -Duser.language=zh -Duser.region=CN -Dfile.encoding=UTF-8 -Duser.timezone=Asia/Shanghai --add-modules java.xml.bind,java.xml.ws,java.xml.ws.annotation
