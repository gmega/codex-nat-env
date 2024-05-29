FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive
ARG CODEX_BINARY

RUN apt-get update && apt-get -y install iproute2 iptables ulogd2 
RUN apt-get install -y tcpdump iputils-ping

RUN mkdir /opt/codex

ENV CODEX_BINARY=${CODEX_BINARY}

COPY ./codex /opt/codex/codex
COPY ./run.sh /opt/codex/run.sh

CMD ["bash", "./opt/codex/run.sh"]
