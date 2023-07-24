#!/bin/bash
# export PS4='$(read time junk < /proc/$$/schedstat; echo "@@@ $time @@@ " )'
# set -x
errors=0
log_file=log.log

GREEN="\e[32m"
RED="\e[31m"
WHITE="\e[0m"

test ()
{
    tmp=$({ $@ 2>&1; echo $? > /tmp/PIPESTATUS; } | tee $log_file)
    rt=$(cat /tmp/PIPESTATUS)
    if [[ $rt -ne 0 ]]; then
        echo -e "[${RED}X${WHITE}] " "$@" ": " "$rt"
        echo "$tmp"
        ((errors += 1))
        return
    fi
    echo -e "[${GREEN}V${WHITE}] " "$@"
}

test docker-compose config -q

# testing docker-compose.yml files
file=$(mktemp)
docker-compose config > "$file" 2>$log_file
test diff test_config.yml "$file"
mv "$file" test_config.yml

# testing environment variables.
grep '${' ./**/docker-compose.*.yml \
    | sed "s/.*\${\(.*\)}.*/\1/g" \
    | cut -d":" -f 1 \
    | sort -u \
    | xargs -I % echo "%=" \
    | sort \
    >> .env.generated
test diff .env.default .env.generated
mv .env.generated .env.default

git diff | tee patch.patch

[ $errors -gt 0 ] && echo "There were $errors errors found" && exit 1

exit 0
# vim: set expandtab
