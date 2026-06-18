# Kiwiprojekt Home Assistant Add-ons

Home Assistant add-ons for [Kiviq Monitor](https://github.com/kiwiprojekt/kiviq-monitor) —
a lightweight, self-hosted server monitoring system. This repository packages two add-ons:

1. **Kiviq Monitor** — runs the central server and embedded dashboard inside Home Assistant.
2. **Kiviq Agent** — reports the Home Assistant host's metrics to a remote monitor.

The add-ons wrap the prebuilt images published from the main project
(`ghcr.io/kiwiprojekt/kiviq-monitor` and `ghcr.io/kiwiprojekt/kiviq-agent`); see that
repository for the architecture, HTTP API, and component details.

## Installation

1. In Home Assistant, go to **Settings** > **Apps** > **App store**.
2. Open the **three dots** menu in the top-right corner and select **Repositories**.
3. Click **+ Add**, paste `https://github.com/kiwiprojekt/ha-apps`, and click **Add**.
4. Close the dialog. Under the **Kiwiprojekt Home Assistant Add-ons** section of the store:
   - Install **Kiviq Monitor** to run the central server/dashboard, or
   - Install **Kiviq Agent** to report this host's metrics to an external monitor.
5. Configure the add-on under its **Configuration** tab and start it.

## Kiviq Monitor

Runs the monitor and dashboard inside Home Assistant. The UI is exposed through Home
Assistant **ingress** — open it from the add-on's sidebar entry; no port or separate
login is needed. Config, TLS material, and the agent registry persist in the add-on's
`/data` directory.

| Option | Type | Default | Purpose |
| --- | --- | --- | --- |
| `monitor_user` | str | `admin` | Dashboard/admin username (set on first bootstrap only). |
| `monitor_password` | password | `changeme` | Dashboard/admin password. **Change this.** |
| `seed_agent` | bool | `true` | Pre-register one agent on first boot so a co-located agent can authenticate immediately. |
| `seed_agent_name` | str | `kiviq-local` | Display name of the seeded agent. |
| `seed_agent_token` | password | `kiviq-agent-token` | Token the seeded agent authenticates with. **Change this.** |

> Seeding only happens once, while no agents exist yet. Changing the seed options later
> has no effect — manage agents from the dashboard's admin UI instead.

## Kiviq Agent

Runs the agent on the Home Assistant host and reports its metrics to a monitor (this
add-on, or a remote one). It uses host networking and the Docker API to read host-level
and container metrics, so it sees the real Home Assistant OS host.

| Option | Type | Default | Purpose |
| --- | --- | --- | --- |
| `monitor_url` | str | `https://your-monitor-address:9753` | Base URL of the monitor to report to. |
| `agent_token` | password | `your-agent-token` | Bearer token; it both authenticates the agent and identifies which agent it reports as (must match a token registered on the monitor). |
| `report_interval` | int | `5` | Seconds between reports. |

## Versioning

Each add-on's `version` (in its `config.yaml`) is pinned to the matching app image tag —
Home Assistant passes it to the Dockerfile as `BUILD_VERSION`, so the add-on always pulls
`ghcr.io/kiwiprojekt/kiviq-*:<version>` rather than a moving `latest`. To update an add-on,
bump its `version` to a published release tag from the main project.

## License

[MIT](LICENSE)
