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

Feel free to do a Pull Request to add your ideas.

[more ideas](https://github.com/awesome-selfhosted/awesome-selfhosted)

## Configuration
Don't forget to change db passwords. (might not be needed since they are beyond
the reverse proxy).
Fill VPN secrets(if none provided, they are generated directly).
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

### Gitlab runner
#### Get the Registration Token
Find your runner registration token (\$REGISTRATION_TOKEN) at
`http://GITLAB_HOST/$PROJECT_GROUP/$PROJECT_NAME/settings/ci_cd`.

There is **two** way to register the runner:

##### Register via the configuration file
Register the Registration Token to have a Runner Token
```bash
curl -X POST 'http://gitlab.${SITE}/api/v4/runners' --form 'token=$REGISTRATION_TOKEN' --form 'description=The Best Runner'
```

###### Change runner configuration
Now change the token in the [configuration file](gitlab/runner/config.toml).
```toml
[[runners]]
    token = "XXXXXXXXXXXXXXXXXXXX"
```
and run the runner
```bash
docker-compose up -d runner
```

##### Register via CLI
Steps:
 - up the runner `docker-compose up -d runner`
 - register the runner

```bash
docker-compose exec runner gitlab-runner register \
    --non-interactive \
    --executor "docker" \
    --docker-image alpine:latest \
    --url "http://gitlab/" \
    --registration-token "$REGISTRATION_TOKEN" \
    --description "The Best Runner" \
    --tag-list "docker,aws" \
    --run-untagged="true" \
    --locked="false" \
    --access-level="not_protected"
```

# Authors
Main author:
 - [Tom](http://tom.moulard.org)

Gitlab helper:
 - [michel_k](mailto:thomas.michelot@epita.fr)

Discord MusicBot:
 - [huvell_m](mailto:martin.huvelle@epita.fr),
see [PR #6](https://github.com/tomMoulard/make-my-server/pull/6)

