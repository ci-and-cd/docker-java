
FROM alpine:3.7

MAINTAINER haolun


ARG IMAGE_ARG_ALPINE_MIRROR

ARG IMAGE_ARG_ENCODING
ARG IMAGE_ARG_LOCALE
ARG IMAGE_ARG_JAVA_OPTS_USER_LANGUAGE
ARG IMAGE_ARG_JAVA_OPTS_USER_REGION


ENV JAVA_HOME /usr/lib/jvm/java-8-oracle



COPY --from=cirepo/waitforit:2.2.0-archive /data/root /
COPY --from=cirepo/alpine-glibc:3.7_2.23-r3-archive /data/root /
COPY --from=cirepo/java-oracle:8u171-archive /data/root /


RUN set -ex \
    && echo ===== Install tools ===== \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/v3.7/main" > /etc/apk/repositories \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/v3.7/community" >> /etc/apk/repositories \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/edge/testing/" >> /etc/apk/repositories \
    && apk add --update --upgrade apk-tools \
    && apk upgrade --update \
    && apk add aria2 bash binutils ca-certificates curl git libstdc++ openssh tar unzip wget xz \
    && rm -rf /tmp/* /var/cache/apk/*



# Install agents
COPY docker/ejstatd-1.0.0.jar /opt/ejstatd/ejstatd-1.0.0.jar
# Need libstdc++.so.6 in libstdc++
# Could not find agent library /opt/jprofiler/bin/linux-x64/libjprofilerti.so in absolute path, with error: libstdc++.so.6: cannot open shared object file: No such file or directory
COPY docker/jprofiler/bin/linux-x64/libattach.so /opt/jprofiler/bin/linux-x64/libattach.so
COPY docker/jprofiler/bin/linux-x64/libjprofilerti.so /opt/jprofiler/bin/linux-x64/libjprofilerti.so
COPY docker/java_debug_monitor_profiler.sh /opt/java_debug_monitor_profiler.sh


# Set runtime environment

ENV JAVA_OPTS -Duser.language=${IMAGE_ARG_JAVA_OPTS_USER_LANGUAGE:-en} -Duser.region=${IMAGE_ARG_JAVA_OPTS_USER_REGION:-US} -Dfile.encoding=${IMAGE_ARG_ENCODING:-UTF-8} -Duser.timezone=${IMAGE_ARG_TZ_AREA:-Etc}/${IMAGE_ARG_TZ_ZONE:-UTC}
ENV LANG ${IMAGE_ARG_LOCALE:-en_US}.${IMAGE_ARG_ENCODING:-UTF-8}
ENV LC_ALL ${IMAGE_ARG_LOCALE:-en_US}.${IMAGE_ARG_ENCODING:-UTF-8}

ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib
ENV PATH ${PATH}:${JAVA_HOME}/bin
