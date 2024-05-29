#!/bin/sh
set -ex

# We
if [ -n "${GATEWAY}" ]; then
    echo "Set ${GATEWAY} as default gateway on eth0"
    ip route change default via ${GATEWAY} dev eth0

    BOOTSTRAP_SPR="--bootstrap-node=$(curl -XGET http://${BOOTSTRAP_NODE}:8080/api/codex/v1/debug/info | jq .spr --raw-output)"
    echo "Bootstrap node SPR is ${BOOTSTRAP_SPR}"
    sleep infinity
fi

tcpdump -i eth0 -n -w /opt/codex/logs/dump.pcap &

echo "Starting codex"

/opt/codex/codex ${BOOTSTRAP_SPR}\
    --data-dir=/opt/codex/data \
    --log-level=INFO;TRACE=autonatservice,relay,relay-client,hpservice,autorelay \
    2>&1 | tee /opt/codex/logs/codex.log
