FROM ubuntu:jammy

ARG DEBIAN_FRONTEND=noninteractive

ARG CODEX_BINARY

RUN apt-get update && apt-get -y install iproute2 iptables ulogd2\
  tcpdump iputils-ping libgomp1 curl jq

RUN mkdir /opt/codex

COPY ./nim-codex/build/codex /opt/codex/codex
COPY ./bin/ /opt/codex/

CMD ["bash", "./opt/codex/run.sh"]
