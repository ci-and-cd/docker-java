
FROM alpine:3.7

MAINTAINER haolun


ARG IMAGE_ARG_ALPINE_MIRROR
ARG IMAGE_ARG_ENCODING
ARG IMAGE_ARG_FILESERVER
ARG IMAGE_ARG_LOCALE

ARG IMAGE_ARG_JAVA_OPTS_USER_LANGUAGE
ARG IMAGE_ARG_JAVA_OPTS_USER_REGION


ENV JDK9_HOME /usr/lib/jvm/java-9-oracle
ENV JRE9_HOME /usr/lib/jvm/java-9-oracle-jre


COPY --from=cirepo/waitforit:2.2.0 /usr/bin/waitforit /usr/bin/waitforit

COPY --from=cirepo/alpine-glibc:3.7_2.25-r0 /data/layer.tar /data/layer.tar
RUN tar xf /data/layer.tar -C /

COPY --from=cirepo/java-9-oracle:9.0.4 /usr/lib/jvm/java-9-oracle /usr/lib/jvm/java-9-oracle
# OSX style JAVA_HOME
RUN JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}') \
    && mkdir -p /Library/Java/JavaVirtualMachines/jdk-${JAVA_VERSION}.jdk/Contents \
    && ln -s ${JDK9_HOME} /Library/Java/JavaVirtualMachines/jdk-${JAVA_VERSION}.jdk/Contents/Home
COPY --from=cirepo/java-9-oracle:9.0.4 /usr/lib/jvm/java-9-oracle-jre /usr/lib/jvm/java-9-oracle-jre
# OSX style JAVA_HOME
RUN JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}') \
    && mkdir -p /Library/Java/JavaVirtualMachines/jre-${JAVA_VERSION}.jre/Contents \
    && ln -s ${JRE9_HOME} /Library/Java/JavaVirtualMachines/jre-${JAVA_VERSION}.jre/Contents/Home

RUN set -ex \
    && echo ===== Install tools ===== \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/v3.7/main" > /etc/apk/repositories \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/v3.7/community" >> /etc/apk/repositories \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/edge/testing/" >> /etc/apk/repositories \
    && apk add --update --upgrade apk-tools \
    && apk upgrade --update \
    && apk add aria2 bash binutils ca-certificates curl git libstdc++ openssh tar unzip wget xz \
    && rm -rf /tmp/* /var/cache/apk/*
#echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf


# Install agents
COPY docker/ejstatd-1.0.0.jar /opt/ejstatd/ejstatd-1.0.0.jar
# Need libstdc++.so.6 in libstdc++
# Could not find agent library /opt/jprofiler/bin/linux-x64/libjprofilerti.so in absolute path, with error: libstdc++.so.6: cannot open shared object file: No such file or directory
COPY docker/jprofiler/bin/linux-x64/libattach.so /opt/jprofiler/bin/linux-x64/libattach.so
COPY docker/jprofiler/bin/linux-x64/libjprofilerti.so /opt/jprofiler/bin/linux-x64/libjprofilerti.so
COPY docker/java_debug_monitor_profiler.sh /opt/java_debug_monitor_profiler.sh


# Set runtime environment
ENV JAVA_HOME ${JDK9_HOME}
ENV JAVA_OPTS -Duser.language=${IMAGE_ARG_JAVA_OPTS_USER_LANGUAGE:-en} -Duser.region=${IMAGE_ARG_JAVA_OPTS_USER_REGION:-US} -Dfile.encoding=${IMAGE_ARG_ENCODING:-UTF-8} -Duser.timezone=${IMAGE_ARG_TZ_AREA:-Etc}/${IMAGE_ARG_TZ_ZONE:-UTC} --add-modules java.xml.bind,java.xml.ws,java.xml.ws.annotation
ENV LANG ${IMAGE_ARG_LOCALE:-en_US}.${IMAGE_ARG_ENCODING:-UTF-8}
ENV LC_ALL ${IMAGE_ARG_LOCALE:-en_US}.${IMAGE_ARG_ENCODING:-UTF-8}
# Do not use "/lib:/usr/lib:/usr/local/lib", java9 will crash
ENV LD_LIBRARY_PATH /usr/glibc-compat/lib
ENV PATH ${PATH}:${JAVA_HOME}/bin
