# Server configuration
[![Docker](https://github.com/tomMoulard/make-my-server/workflows/Docker/badge.svg)](https://github.com/tomMoulard/make-my-server/actions)

## Setup
```bash
docker-compose ()
{
    docker-compose $(find -name 'docker-compose*.yml' -type f -printf '%p\t%d\n'  2>/dev/null | sort -n -k2 | cut -f 1 | awk '{print "-f "$0}') $@
}
SITE=tom.moulard.org docker-compose up -d
```

Now you have my own server configuration.

To be a little more consistent with the management, you can use a `.env` file
and do:
```bash
cp .env.default .env
```

And edit the file to use the correct site URL.

The `docker-compose` function gather all docker-compose files in order to have
the whole configuration in one place (see `docker-compose config`).

### Tear down
```bash
docker-compose down
```

### Services list
There **should** be only one service by folder:
For example, le folder `traefik/` contains all the necessary configuration to
run the `traefik` service.

Thus each folder represent an available service.

The directory must follow the following architecture:
```
service/
├── conf
│   └── ...
├── data
│   └── ...
├── docker-compose.servicename.yml
├── logs
│   ├── access.log
│   └── error.log
└── README.md
```

If the service you are adding can use volumes:
 - `data/`, is where to store to service data
 - `conf/`, is where to store to service configuration
 - `logs/`, is where to store to service logs (others than Docker logs)

Feel free to do a Pull Request to add your ideas.

[more ideas](https://github.com/awesome-selfhosted/awesome-selfhosted)

## Configuration
Don't forget to change:

 - db passwords (might not be needed since they are beyond the reverse proxy)
 - VPN secrets (if none provided, they are generated directly).

Configuration files are: `docker-compose.yml`, `nginx.conf`

To set the password:
```bash
echo "USERS=$USER:$(openssl passwd -apr1)" >> .env
```

You can add a new set of credentials by editing the .env file like
```env
USERS=toto:pass,tata:pass, ...
```

### For local developments
Edit the file `/etc/hosts` to provide the reverse proxy with good URLs.

For example, adding this in your `/etc/hosts` will allow to run and debug the
Traefik service locally:
```bash
127.0.0.1   traefik.moulard.org
```

### Scaling up
```bash
docker-compose scale nginx=2
```

# Authors
Main author:
 - [Tom](http://tom.moulard.org)

Gitlab helper:
 - [michel_k](mailto:thomas.michelot@epita.fr)

Discord MusicBot/minecraft:
 - [huvell_m](mailto:martin.huvelle@epita.fr),
see PR [#6](https://github.com/tomMoulard/make-my-server/pull/6)

