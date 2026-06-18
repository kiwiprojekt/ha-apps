#!/usr/bin/env bashio

# Read options straight from the file Supervisor writes, rather than
# bashio::config — which now goes through the Supervisor API and needs API
# access this add-on can't get under host networking (it returns 403).
OPTIONS=/data/options.json

export MONITOR_URL="$(jq -r '.monitor_url // empty' "${OPTIONS}")"
export AGENT_TOKEN="$(jq -r '.agent_token // empty' "${OPTIONS}")"
export REPORT_INTERVAL="$(jq -r '.report_interval // empty' "${OPTIONS}")"
export AGENT_CA_DIR="/data"

# With docker_api: true, Supervisor bind-mounts the host Docker socket at
# /run/docker.sock. The agent's Docker client honours DOCKER_HOST, so point it
# there (its default is /var/run/docker.sock, which isn't where HA mounts it).
export DOCKER_HOST="unix:///run/docker.sock"

bashio::log.info "Starting Kiviq Agent reporting to ${MONITOR_URL}..."
exec /app/agent
