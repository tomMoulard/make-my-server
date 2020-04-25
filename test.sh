#!/bin/bash
set -e
errors=0
log_file=log.log

GREEN="\e[32m"
RED="\e[31m"
WHITE="\e[0m"

dc ()
{
    docker-compose $(find . -name "docker-compose*.yml" -type f -exec printf " -f {}" \; 2>$log_file) $@
}

test ()
{
    tmp=$($@ 2>$log_file 1>$log_file)
    rt=$?
    if [[ $rt -ne 0 ]]; then
        printf "[${RED}X${WHITE}] $@: $rt"
        echo
        ((errors += 1))
        return
    fi
    printf "[${GREEN}V${WHITE}] $@"
    echo
}

# set -x #debug

test dc config -q

file=$(mktemp) && dc config > $file 2>$log_file && test diff test_config.yml $file && rm $file

[ $errors -gt 0 ] && printf "There were $errors errors found\n" && exit 1

