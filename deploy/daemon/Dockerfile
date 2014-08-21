FROM        ubuntu:14.04
MAINTAINER  robert@hyperdex.org

RUN apt-get update
RUN apt-get install -y wget
RUN wget -O - http://ubuntu.hyperdex.org/hyperdex.gpg.key | apt-key add -
RUN wget -O /etc/apt/sources.list.d/hyperdex.list http://ubuntu.hyperdex.org/trusty.list
RUN apt-get update
RUN apt-get install -y hyperdex-daemon

EXPOSE 2012

RUN mkdir -p /hyperdex/daemon
VOLUME /hyperdex
