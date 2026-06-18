#!/usr/bin/env sh

# Read options from the file Supervisor writes (no bashio: the Supervisor API
# returns 403 for this add-on, and this image isn't the bashio base anyway).
OPTIONS=/data/options.json

export MONITOR_URL="$(jq -r '.monitor_url // empty' "${OPTIONS}")"
export AGENT_TOKEN="$(jq -r '.agent_token // empty' "${OPTIONS}")"
export REPORT_INTERVAL="$(jq -r '.report_interval // empty' "${OPTIONS}")"
export AGENT_CA_DIR="/data"

# Supervisor mounts the host Docker socket here when docker_api: true.
export DOCKER_HOST="unix:///run/docker.sock"

# host_pid: true shares the host PID namespace, so the host root filesystem is
# reachable at /proc/1/root. The agent reads host identity (hostname,
# os-release) from there instead of from the container. Requires protection
# mode to be OFF for the add-on, or host_pid is ignored.
export AGENT_HOST_ROOT="/proc/1/root"

echo "Starting Kiviq Agent reporting to ${MONITOR_URL}..."
exec /app/agent
