# Authelia

https://www.authelia.com/


It has never been so easy to secure your applications with Single Sign-On and Two-Factor.

With Authelia you can login once and get access to all your web apps safely from the Web thanks to two-factor authentication.

Authelia is an open source authentication and authorization server protecting modern web applications by collaborating with reverse proxies such as NGINX, Traefik and HAProxy. Consequently, no code is required to protect your apps.

# Installation
This installation is far from prefect.

## Secrets
Create secrets and place them in the folder `authelia/secrets` like:
```bash
openssl rand -base64 32768 > authelia/secrets/jwt
openssl rand -base64 32768 > authelia/secrets/session
```

If you change the `authelia-postgres` password, change it in the secret file too : `authelia/secrets/postgres`.

To send emails, put your password in the file `authelia/secrets/smtp`.

## Adding passwords in the user_database.yml
```bash
cat MY_PASSWORD | docker run authelia/authelia:latest authelia hash-password -
# Or
docker run authelia/authelia:latest authelia hash-password MY_PASSWORD
```

## Creating access control rules
> see [documentation](https://www.authelia.com/docs/configuration/access-control.html)

I've put some good default configuration, you need to replace `example.com` by your website.

Here are some groups I've defined to 'sort' your users:

|group  |usage                   |
|-------|------------------------|
|admin  |access to all           |
|dev    |access to monitoring/dev|
|torrent|access to torrents      |

You can easily change policies for each groups by looking at rules

# Adding authelia to another service
Add this to you service's labels:
```yml
 - 'traefik.frontend.auth.forward.address=http://authelia:9091/api/verify?rd=https://authelia.${SITE}/'
 - 'traefik.frontend.auth.forward.trustForwardHeader=true'
 - 'traefik.frontend.auth.forward.authResponseHeaders=Remote-User,Remote-Groups,Remote-Name,Remote-Email'
```

For example, nginx service would look like:
```yml
version: '2'

services:
  nginx:
    image: nginx:stable-alpine
    volumes:
      - './nginx/conf:/etc/nginx/conf.d'
      - './nginx/logs:/var/log/nginx/'
    networks:
      - 'srv'
    restart: always
    healthcheck:
      test: ['CMD', 'curl', '0.0.0.0:80']
      interval: 10s
      timeout: 10s
      retries: 5
    labels:
      - 'traefik.enable=true'
      - 'traefik.frontend.rule=Host:${SITE}'
      - 'traefik.port=80'
      - 'traefik.frontend.auth.forward.address=http://authelia:9091/api/verify?rd=https://authelia.${SITE}/'
      - 'traefik.frontend.auth.forward.trustForwardHeader=true'
      - 'traefik.frontend.auth.forward.authResponseHeaders=Remote-User,Remote-Groups,Remote-Name,Remote-Email'
```
