# vim:set ft=dockerfile:
FROM library/ubuntu:14.04
MAINTAINER 04n0

ARG UNIXBENCHVERSION=5.1.3

# set debian frontend to noninteractive during the build process
ARG DEBIAN_FRONTEND=noninteractive
# apply utf-8 locales
RUN locale-gen en_US.utf8 && locale -a && dpkg-reconfigure locales
# set environment variables for build process
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm
# update repositories and perform upgrade of packages, if applicable
RUN apt-get update && \
    apt-get upgrade -y && \
# install build packages and tools
    apt-get install -y build-essential make perl perl-modules libx11-dev libgl1-mesa-dev libxext-dev curl info && \
# download unixbench
    mkdir -p /app && curl -LsS https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/byte-unixbench/UnixBench${UNIXBENCHVERSION}.tgz | tar -zxf - -C /app && chmod +x /app/UnixBench/Run && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

WORKDIR /app/UnixBench

ENTRYPOINT ["/app/UnixBench/Run"]
