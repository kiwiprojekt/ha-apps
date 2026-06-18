# Pin the app image to this add-on's version. Home Assistant passes the
# config.yaml `version` in as BUILD_VERSION. --from can't expand a variable, so
# the versioned image is pulled as a named build stage instead. Bumping the
# add-on version repins it. Falls back to :latest for manual `docker build`
# outside Home Assistant.
ARG BUILD_VERSION=latest
FROM ghcr.io/kiwiprojekt/kiviq-monitor:${BUILD_VERSION} AS app

FROM ghcr.io/home-assistant/base:latest

# Copy the prebuilt monitor binary and web assets from the official image
COPY --from=app /kiviq /app/monitor
COPY --from=app /app/web/dist /app/web/dist

# Copy the wrapper script
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
