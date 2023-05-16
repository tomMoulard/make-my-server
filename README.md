# Server configuration
[![Docker](https://github.com/tomMoulard/make-my-server/workflows/Docker/badge.svg)](https://github.com/tomMoulard/make-my-server/actions)
[![Discord](https://img.shields.io/discord/861623516142501898)](https://discord.gg/zQV6m9Jk6Z)

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
echo "USERS=$(htpasswd -nB $USER)" >> .env
```

You can add a new set of credentials by editing the .env file like
```env
USERS=toto:pass,tata:pass, ...
```

The `.env.default` is generated using this command:
```bash
grep '${' **/docker-compose.*.yml | sed "s/.*\${\(.*\)}.*/\1/g" | cut -d":" -f 1 | sort -u | sort | xargs -I % echo "%=" >> .env.default
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

## Tests

### Lint

! Warning: This is enforced for all PRs.

We are using yamllint to lint our yaml files.
You can install it by looking at the [official
documentation](https://yamllint.readthedocs.io/en/stable/quickstart.html#installation).

Once installed, you can run the following command to lint all the yaml files:
```bash
yamllint .
```

### docker-compose config

! Warning: This is enforced for all PRs.

You can run the following command to check that the docker-compose files are
correctly written:
```bash
./test.sh
```

It tests that:

 - all docker-compose files are valid
 - all docker-compose files are parsable
 - all docker-compose files are consistent with the test_config.yml file
 - all environment variables are set inside the `.env.default` file

Once this shell scritp is run, if the tests failes, you can see a bunch of
modified files (e.g., `test_config.yml`) that indicates what is wrong.

Note that the GitHub Action will run this script for you, and provides a
`patch.patch` file that **should** solve most of your issues.

# Authors
Main author:
 - [Tom](http://tom.moulard.org)

Gitlab helper:
 - [michel_k](mailto:thomas.michelot@epita.fr)

Discord MusicBot/minecraft:
 - [huvell_m](mailto:martin.huvelle@epita.fr),
see PR [#6](https://github.com/tomMoulard/make-my-server/pull/6)

