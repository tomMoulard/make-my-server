# traefik

https://doc.traefik.io/traefik/

Traefik is an open-source Edge Router that makes publishing your services a fun
and easy experience. It receives requests on behalf of your system and finds
out which components are responsible for handling them. What sets Traefik
apart, besides its many features, is that it automatically discovers the right
configuration for your services.

## DNS entrypoint for Pi-hole

Traefik now terminates both TCP and UDP DNS traffic for Pi-hole. The
`dns-tcp`/`dns-udp` entrypoints listen on port 53 by default (configurable via
`TRAEFIK_DNS_ENTRYPOINT` in your `.env`). Make sure no local resolver (for
example `systemd-resolved`) is bound to that port before starting Traefik. If
you need a custom port, set `TRAEFIK_DNS_ENTRYPOINT=<port>` and update every DNS
client to query Traefik on the same port.

## Add a Router/Service using the file provider
To create a new router and/or a new service, you can use the file provider:

Simply create a new file inside the `./traefik/dynamic_conf` folder with this
content:
```yml
http:
  # Add the router
  routers:
    service-example-router:
      service: service-example
      rule: Host(`example.localhost`)

  # Add the service
  services:
    service-example:
      loadBalancer:
        servers:
          - url: http://example.com
```
