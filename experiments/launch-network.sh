#!/usr/bin/env bash
#
# Yet another script for launching a simple codex network on terminals.
set -ex

N_NODES="${1}"

if [ -z "${N_NODES}" ]; then
  echo "Usage: $0 <number of nodes>"
  exit 1
fi

script_path=$(dirname $(realpath "$0"))
data_path="${script_path}/data"
logs_path="${script_path}/logs"
codex_binary="$(dirname "${script_path}")/codex/nim-codex/build/codex"

if [ ! -f "${codex_binary}" ]; then
  echo "Codex binary not found at ${codex_binary}. Run make"
  exit 1
fi

# Create a containerless network
for i in $(seq 1 ${N_NODES}); do
  node_index=$((i - 1))
  node_data_path="${data_path}/node-${node_index}"
  node_logs_path="${logs_path}/node-${node_index}"
  
  api_port=$((8080 + ${node_index}))
  listen_port=$((8000 + ${node_index}))
  discovery_port=$((9000 + ${node_index}))

  mkdir -p "${node_data_path}" "${node_logs_path}"

  codex_cmd=(
    "${codex_binary}"
    "--data-dir=${node_data_path}"
    "--log-level='INFO;trace:autonatservice,relay,relay-client,hpservice,autorelay'"
    "--api-bindaddr=0.0.0.0"
    "--api-port=${api_port}"
    "--listen-addrs=/ip4/0.0.0.0/tcp/${listen_port}"
    "--disc-port=${discovery_port}"
  )

  if [ -n "${bootstrap_spr}" ]; then
    codex_cmd+=("--bootstrap-node=${bootstrap_spr}")
  fi

  cmd_str="${codex_cmd[@]} 2>&1 | tee ${node_logs_path}/codex.log"

  gnome-terminal -- bash -c  "${cmd_str}" &

  if [ -z "${bootstrap_spr}" ]; then
    bootstrap_spr=$(curl --retry 10 --retry-delay 1 --retry-connrefused http://localhost:8080/api/codex/v1/debug/info | jq .spr --raw-output)
    echo "Bootstrap node SPR is ${bootstrap_spr}"
  fi
done