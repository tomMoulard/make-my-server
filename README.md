# Server configuration

## Goal
```bash
$ export SITE=tom.moulard.org
$ docker-compose up -d
```

Now you have my own server configuration


## TODO
### New ideas
 - [X] traefik
 - [X] gitlab
 - [X] nextcloud
    - [ ] CI/CD worker(s)
 - [X] nginx
 - [X] weechat
 - [X] transmission
 - [X] vpn
 - [X] jupyter
 - [ ] readthedoc / [DokuWiki](https://hub.docker.com/r/mprasil/dokuwiki)
 - [X] pastebin
 - [ ] image hosting
 - [ ] [hackmd](https://github.com/hackmdio/docker-hackmd) [main repo](https://github.com/hackmdio/codimd)
 - [ ] jekyll
 - [ ] [monitoring](https://www.brianchristner.io/how-to-monitor-traefik-reverse-proxy-with-prometheus/)
 - [ ] proxy
 - [ ] [RSS agregator server](https://www.freshrss.org/)
 - [ ] calendar
 - [ ] url shortener
 - [ ] File host [jirafeau](https://jirafeau.net/)
 - [ ] DNS updater
 - [ ] factorio server
 - [ ] news group server
 - [ ] vlc server
 - [ ] blog
[more](https://github.com/Kickball/awesome-selfhosted)

### List
 - [ ] which database ? maria / mysql / mongo / postgres
    - [ ] gitlab postgresSQL / MySQL - MariaDB
    - [ ] nextcloud postgresSQL / MySQL - MariaDB / Oracle
 - [X] nginx.conf
 - [ ] create a git repository auto in gitlab for // FIXME
 - [ ] Create a Dockerfile for a mail server
 - [X] reverse proxy with ssl
 - [ ] multi files configuration
 - [ ] Testing
    - [X] traefik
    - [X] gitlab
    - [ ] nextcloud
    - [X] nginx
    - [ ] weechat
    - [X] transmission
    - [X] vpn
    - [X] jupyter
    - [X] pastebin

### Configuration files
 - [ ] have default configuration files
    - [X] traefik
    - [ ] gitlab
    - [ ] gitlab runner
    - [ ] transmission
    - [ ] pastebin
    - [ ] nextcloud
    - [X] nginx

## Configuration
Don't forget to change db passwords. (migth not be needed since they are beyond
the reverse proxy).
Fill vpn secrets(if none provided, they are generated directly).
Configuration files are: `docker-compose.yml`, `nginx.conf`

### Scalling up
```bash
docker-compose scale nginx=2
```

### Adress table
| Status | Address | port(s)|
|:--:|--|--|
| [X] | traefik.${SITE} | 80, 443 (redirect 80 to 443) |
| [X] | gitlab.${SITE} | 22, 80, 443 |
| [ ] | cloud.${SITE} | 80, 443 |
| [X] | ${SITE} | 80, 443 |
| [ ] | mail.${SITE} | 25(recv mail), 465(ssl), 587(TLS), 143(IMAP), 993(IMAP), 110(POP3), 995(POP3) |
| [X] | torrent.${SITE} | 80, 443 (redirect 80 to 443) |
| [X] | vpn.${SITE} | 500, 4500 |
| [X] | jupiter.${SITE} | 80, 443 (redirect 80 to 443) |
| [X] | paste.${SITE} | 80, 443 (redirect 80 to 443) |
| [ ] | irc.${SITE} | ?? |

### Miscellaneous
| Status | Address | port(s)|
|:--:|--|--|
| [X] | ${SITE2} | 80, 443 (redirect 80 to 443) |


## Installation
### Traefik
```
defaultEntryPoints = ["http", "https"]

[entryPoints]
  [entryPoints.http]
    address = ":80"
      [entryPoints.http.redirect]
        entryPoint = "https"
  [entryPoints.https]
    address = ":443"
      [entryPoints.https.tls]

# API definition
[api]
entryPoint = "traefik"
dashboard = true
  [api.statistics]
    recentErrors = 42

[[acme.domains]]
main = "${SITE}"
sans = ["paste.${SITE}", "traefik.${SITE}", "gitlab.${SITE}"]

[acme]
email = "${EMAIL}"
storage = "acme.json"
entryPoint = "https"
onHostRule = true
  [acme.httpChallenge]
  entryPoint = "http"

[docker]
watch = true
exposedByDefault = false
```
### Nginx
Configuration file to put in `$HOME/srv/nginx/nginx.conf`
```
server {
    root /etc/nginx/conf.d/www;
    index index.html;

    location /{
        try_files $uri $uri/ =404;
        autoindex on;
    }
}
```

And put your files in the folder `$HOME/srv/nginx/www`.