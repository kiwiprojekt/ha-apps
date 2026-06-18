#!/usr/bin/env bashio

# Read options straight from the file Supervisor writes, rather than
# bashio::config — which now goes through the Supervisor API and needs API
# access this add-on can't get under host networking (it returns 403).
OPTIONS=/data/options.json

export MONITOR_URL="$(jq -r '.monitor_url // empty' "${OPTIONS}")"
export AGENT_TOKEN="$(jq -r '.agent_token // empty' "${OPTIONS}")"
export REPORT_INTERVAL="$(jq -r '.report_interval // empty' "${OPTIONS}")"
export AGENT_CA_DIR="/data"

bashio::log.info "Starting Kiviq Agent reporting to ${MONITOR_URL}..."
exec /app/agent
