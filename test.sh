#!/bin/bash
# set -e
errors=0
log_file=log.log

GREEN="\e[32m"
RED="\e[31m"
WHITE="\e[0m"

dc ()
{
    docker-compose $(find -name 'docker-compose*.yml' -type f -printf '%p\t%d\n'  2>/dev/null | sort -n -k2 | cut -f 1 | awk '{print "-f "$0}') $@
}

test ()
{
    tmp=$($@ 2>$log_file 1>$log_file)
    rt=$?
    if [[ $rt -ne 0 ]]; then
        echo -e "[${RED}X${WHITE}] $@: $rt"
        ((errors += 1))
        return
    fi
    echo -e "[${GREEN}V${WHITE}] $@"
}

test dc config -q

file=$(mktemp)
dc config > $file 2>$log_file
test diff test_config.yml $file
mv $file test_config.yml

grep '${' **/docker-compose.*.yml | sed "s/.*\${\(.*\)}.*/\1/g" | cut -d":" -f 1 | sort -u | xargs -I % echo "%=" | sort >> .env.generated
test diff .env.default .env.generated
mv .env.generated .env.default

git diff | tee patch.patch

[ $errors -gt 0 ] && echo "There were $errors errors found" && exit 1

exit 0
