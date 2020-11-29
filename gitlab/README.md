# Gitlab
https://about.gitlab.com/

GitLab is a web-based DevOps lifecycle tool that provides a Git-repository
manager providing wiki, issue-tracking and continuous integration and
deployment pipeline features, using an open-source license, developed by
GitLab Inc. The software was created by Ukrainian developers Dmitriy
Zaporozhets and Valery Sizov.

## Gitlab runner
### Get the Registration Token
Find your runner registration token (\$REGISTRATION_TOKEN) at
`http://GITLAB_HOST/$PROJECT_GROUP/$PROJECT_NAME/settings/ci_cd`.

There is **two** way to register the runner:
### Register via CLI
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

### Register via the configuration file
Register the Registration Token to have a Runner Token
```bash
curl -X POST 'http://gitlab.${SITE}/api/v4/runners' --form 'token=$REGISTRATION_TOKEN' --form 'description=The Best Runner'
```

#### Change runner configuration
Now change the token in the [configuration file](gitlab/runner/config.toml).
```toml
[[runners]]
    token = "XXXXXXXXXXXXXXXXXXXX"
```
and run the runner
```bash
docker-compose up -d runner
```

