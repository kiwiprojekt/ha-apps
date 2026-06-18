# Pin the app image to this add-on's version. Home Assistant passes the
# config.yaml `version` in as BUILD_VERSION. --from can't expand a variable, so
# the versioned image is pulled as a named build stage instead.
ARG BUILD_VERSION=latest
FROM ghcr.io/kiwiprojekt/kiviq-agent:${BUILD_VERSION} AS app

# Plain Alpine base, not the s6-based Home Assistant base image: this add-on
# needs host_pid (to read host data via /proc/1/root), which puts the container
# in the host PID namespace where s6-overlay refuses to start ("can only run as
# pid 1"). Running the agent binary directly sidesteps that conflict.
FROM alpine:3.19
RUN apk add --no-cache jq ca-certificates

COPY --from=app /kiviq /app/agent

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
