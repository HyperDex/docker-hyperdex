FROM        debian:6
MAINTAINER  robert@hyperdex.org

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install -y build-essential chrpath python wget

ADD build.sh /root/build.sh
ADD replicant-makefile.patch /root/replicant-makefile.patch
ADD hyperdex-makefile.patch /root/hyperdex-makefile.patch

CMD /root/build.sh
