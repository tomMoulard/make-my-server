# Home Assistant

https://www.home-assistant.io

Open source home automation that puts local control and privacy first. Powered
by a worldwide community of tinkerers and DIY enthusiasts. Perfect to run on a
Raspberry Pi or a local server.

Note that traefik's basic auth cannot be used with home assistant, as
[HA does not support](https://github.com/home-assistant/iOS/issues/193#issuecomment-760662881)
using the `Authorization` header for anything else than HA.


## configuration

To enable [prometheus metrics](https://www.home-assistant.io/integrations/prometheus/),
add the following to your `configuration.yaml`:

```yaml
prometheus:
```

You can also [configure basic informations](https://www.home-assistant.io/docs/configuration/basic/)
about your home assistant instance by setting the `homeassistant` key in your
`configuration.yaml`. It is the recommended way to configure your instance as
is is not possible to secure the instance with traefik's basic auth.

Here is how to tell HA that it is [behind](https://www.home-assistant.io/integrations/http/#reverse-proxies)
a reverse proxy:

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 127.0.0.1   # localhost
    - ::1         # localhost but in IPv6
    - 172.0.0.0/8 # docker network
```
