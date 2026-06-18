#!/usr/bin/env bashio

# Read options straight from the file Supervisor writes, rather than
# bashio::config — which now goes through the Supervisor API and needs API
# access this add-on can't get (it returns 403).
OPTIONS=/data/options.json

# Home Assistant persistent data directory
export KIVIQ_CONFIG="/data/config.json"

# Serve plain HTTP — Home Assistant ingress terminates TLS and connects to the
# add-on over HTTP on its internal network.
export KIVIQ_HTTP=1

export KIVIQ_MONITOR_USER="$(jq -r '.monitor_user // empty' "${OPTIONS}")"
export KIVIQ_MONITOR_PASSWORD="$(jq -r '.monitor_password // empty' "${OPTIONS}")"

# Seed an agent on first boot only when enabled in the UI options.
if [ "$(jq -r '.seed_agent // false' "${OPTIONS}")" = "true" ]; then
    export KIVIQ_SEED_AGENT_NAME="$(jq -r '.seed_agent_name // empty' "${OPTIONS}")"
    export KIVIQ_SEED_AGENT_TOKEN="$(jq -r '.seed_agent_token // empty' "${OPTIONS}")"
fi

bashio::log.info "Starting Kiviq Monitor..."
exec /app/monitor
