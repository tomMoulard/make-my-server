# Pi-hole

[Pi-hole](https://pi-hole.net/) is a network-wide DNS sinkhole that blocks ads
and trackers for every device on your network.

This service definition deploys Pi-hole behind Traefik so the admin interface is
available securely at `https://pihole.${SITE}` while DNS requests continue to be
served directly on port 53.

## Volumes

- `./etc-pihole` → `/etc/pihole` (gravity database, lists, custom configs)
- `./etc-dnsmasq.d` → `/etc/dnsmasq.d` (dnsmasq overrides, DHCP config)
- `./logs` → `/var/log/lighttpd` (web UI access/error logs)

Back up these folders before upgrading or recreating the container to retain
settings, blocklists, and DHCP leases.

## Environment variables

| Variable | Default | Description |
| --- | --- | --- |
| `PIHOLE_IMAGE_VERSION` | `2024.05.0` | Pi-hole Docker image tag |
| `PIHOLE_WEBPASSWORD` | `changeme` | Admin UI password; override in `.env` |
| `PIHOLE_V4_ADDRESS` | `0.0.0.0` | IP address Pi-hole advertises to clients |
| `PIHOLE_V6_ADDRESS` | `::` | IPv6 address Pi-hole advertises |
| `PIHOLE_HOSTNAME` | `pihole` | Hostname shown in the UI and DHCP replies |
| `PIHOLE_DNS1` | `1.1.1.1` | Primary upstream DNS |
| `PIHOLE_DNS2` | `1.0.0.1` | Secondary upstream DNS |
| `PIHOLE_DNSMASQ_LISTENING` | `all` | dnsmasq listening mode (`local`, `all`) |
| `PIHOLE_REV_SERVER` | `false` | Enable conditional forwarding |
| `PIHOLE_REV_SERVER_TARGET` | `192.168.0.1` | Router/DNS to forward PTR queries |
| `PIHOLE_REV_SERVER_DOMAIN` | `lan` | Local domain for reverse lookups |
| `PIHOLE_REV_SERVER_CIDR` | `192.168.0.0/24` | Subnet for reverse lookups |
| `SITE` | `localhost` | Used to build the admin UI host `pihole.${SITE}` |
| `TZ` | `Europe/Paris` | Container timezone |
| `TRAEFIK_DNS_ENTRYPOINT` | `53` | Port that Traefik exposes for DNS (defined in the Traefik service) |

The DNS port exposed to your network is now configured globally via
`TRAEFIK_DNS_ENTRYPOINT` and defaults to 53.

Update `.env` (copied from `.env.default`) with secure values, especially
`PIHOLE_WEBPASSWORD`.

## DNS port requirements

Traefik now terminates all DNS traffic for Pi-hole. It binds both TCP and UDP
port 53 by default (configurable via `TRAEFIK_DNS_ENTRYPOINT`) and proxies the
traffic to the Pi-hole container over the internal `srv` network. Make sure the
host resolver (`systemd-resolved`, dnsmasq, etc.) is disabled or moved away from
that port before starting Traefik, otherwise Traefik cannot bind to it.

1. Disable the built-in resolver (for example `sudo systemctl disable --now
   systemd-resolved` on Ubuntu) and restart Docker so the ports are freed.
2. If you must keep another resolver running locally, set
   `TRAEFIK_DNS_ENTRYPOINT` in `.env` to an alternate port and point every DNS
   client to that same port on the Traefik host.

## Traefik integration

- The compose file registers Pi-hole with Traefik using the shared `srv` network.
- The router `pihole` matches `Host(`pihole.${SITE}`)` and explicitly targets the
  `websecure` entrypoint so TLS is always negotiated.
- The DNS routers `pihole-dns` bind to the `dns-tcp` and `dns-udp` entrypoints so
  Traefik proxies raw DNS queries on port 53 to the container without exposing
  any Pi-hole ports.
- Certificates are handled by Traefik via the globally configured ACME resolver.

The admin UI relies on Pi-hole’s own `WEBPASSWORD`. If you want an additional
basic-auth prompt, add the standard middleware labels from the `traefik` service
(or create a dedicated middleware in `dynamic_conf/`) before exposing the route.


## DNS configuration steps

1. Deploy the service: `SITE=example.com docker-compose up -d pihole` (or run the
   global helper to start every service).
2. Point your network clients (router DHCP option or manual DNS setting) to the
   host running Traefik on port `${TRAEFIK_DNS_ENTRYPOINT:-53}`.
3. Access `https://pihole.${SITE}` to finish the web-based setup and verify that
   queries are being processed.

### Optional DHCP support

If you want Pi-hole to serve DHCP, you still need to grant it `NET_ADMIN` and
expose UDP/67 directly (Traefik does not proxy DHCP). Create an override such as:

```yml
services:
  pihole:
    cap_add:
      - NET_ADMIN
    ports:
      - '67:67/udp'
```

This reintroduces a host port mapping, so only enable it if no other DHCP server
is active on your LAN and you understand the exposure.


## Maintenance

- Update Pi-hole with `docker-compose pull pihole && docker-compose up -d pihole`.
- Review logs in `pihole/logs/` or via the web UI if troubleshooting.
- Export blocklists or settings regularly from the admin UI in addition to
  filesystem backups.
