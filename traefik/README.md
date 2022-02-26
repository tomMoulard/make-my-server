# traefik

https://doc.traefik.io/traefik/

Traefik is an open-source Edge Router that makes publishing your services a fun
and easy experience. It receives requests on behalf of your system and finds
out which components are responsible for handling them. What sets Traefik
apart, besides its many features, is that it automatically discovers the right
configuration for your services.

## Register your instance to [pilot](https://pilot.traefik.io)
You can add your pilot token using the `TRAEFIK_PiLOT_TOKEN` environment
variable.

You can add this to your `.env` file:
```bash
echo "TRAEFIK_PiLOT_TOKEN=$MY_TOKEN" >> .env
```

Once you have registered your instance, you can provide use plugins by setting the `TRAEFIK_PLUGINS` variable:
```bash
echo 'TRAEFIK_PLUGINS=,fail2ban@file' >> .env
```

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
