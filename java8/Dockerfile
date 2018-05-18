# ${DOCKER_REGISTRY}/java:oracle-8u171-jdk-alpine
#
# The main caveat to note is that it does use musl libc instead of glibc and friends,
# so certain software might run into issues depending on the depth of their libc requirements.
# However, most software doesn't have an issue with this,
# so this variant is usually a very safe choice.
#



FROM alpine:3.7





MAINTAINER haolun

ARG build_fileserver
ENV ARIA2C_DOWNLOAD aria2c --file-allocation=none -c -x 10 -s 10 -m 0 --console-log-level=notice --log-level=notice --summary-interval=0

ENV JAVA_HOME /opt/jdk

# Smaller Java images with Alpine Linux
# see: https://developer.atlassian.com/blog/2015/08/minimal-java-docker-containers/



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
    && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh

ADD docker/install_waitforit.sh /root/
RUN /root/install_waitforit.sh

ADD docker/install_glibc.sh /root/
RUN /root/install_glibc.sh

ADD docker/install_oracle_jdk.sh /root/
RUN /root/install_oracle_jdk.sh






























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


ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib

ENV JAVA_OPTS -Duser.language=zh -Duser.region=CN -Dfile.encoding=UTF-8 -Duser.timezone=Asia/Shanghai
