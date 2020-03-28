FROM ubuntu:latest as q3build
LABEL name=q3build

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y git make gcc

#RUN git clone --depth 1 https://github.com/ioquake/ioq3.git /opt/ioq3
ADD ioq3.tgz /opt

WORKDIR /opt/ioq3

ENV BUILD_CLIENT=0 BUILD_SERVER=1 USE_CURL=1 USE_CODEC_OPUS=1 USE_VOIP=1 COPYDIR=/opt/ioquake3

RUN make && make -j2 && make copyfiles



FROM ubuntu:latest

COPY --from=q3build /opt/ioquake3 /opt/ioquake3

ADD extras.tgz /opt/ioquake3

COPY server.cfg /opt/ioquake3/baseq3

RUN useradd -m ioq3srv
USER ioq3srv

ENTRYPOINT ["/opt/ioquake3/ioq3ded.x86_64", "+set", "dedicated", "2", "+set", "com_hunkmegs", "64", "+exec", "server.cfg"]

