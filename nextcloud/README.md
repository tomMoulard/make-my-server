# NextCloud

http://nextcloud.com/

NextCloud is a suite of client-server software for creating and using file
hosting services. NextCloud is free and open-source, which means that anyone is
allowed to install and operate it on their own private server devices.

With the integrated OnlyOffice, NextCloud application functionally is similar
to Dropbox, Office 365 or Google Drive, but can be used on home-local computers
or for off-premises file storage hosting.

The original OwnCloud developer Frank Karlitschek forked OwnCloud and created
NextCloud, which continues to be actively developed by Karlitschek and other
members of the original OwnCloud team.

## Setup

### Cron

Ajax is the default, but cron is the best

To setup cron, add this line to your crontab:
```
*/5   *    *   *     *           docker exec -u www-data make-my-server-nextcloud-1 php -f cron.php
```

Which should lead to:
```bash
$ crontab -l
...
#min hour day Month Day_Of_Week Command
*/5   *    *   *     *           docker exec -u www-data make-my-server-nextcloud-1 php -f cron.php
```

### Database

If you forgot to install NextCloud with its dedicated database, you can run this command to migrate from anything to the mariadb instance:
```
docker-compose exec -u www-data nextcloud php occ db:convert-type --all-apps --port 3306 --password nextcloud mysql nextcloud nextcloud-db nextcloud
```

## Upgrade
How to upgrade your NextCloud instance:
```bash
docker-compose pull nextcloud
docker-compose stop nextcloud && docker-compose up -d nextcloud
docker-compose exec -u www-data nextcloud php occ upgrade -vvv
```

To remove maintenance mode:
```bash
docker-compose exec -u www-data nextcloud php occ maintenance:mode --off
```

## Misc

### Re apply the configuration

If you want to re apply the configuration of NextCloud, you can always run this:
```bash
docker-compose exec -u www-data nextcloud php occ maintenance:repair -vvv
```

### php-imagick

To fix this issue:
```
Module php-imagick in this instance has no SVG support. For better compatibility it is recommended to install it.
```

Run:

```bash
docker-compose exec nextcloud apt -y install libmagickcore-6.q16-6-extra
```

### default_phone_region

To fix this issue:
```
ERROR: Can not validate phone numbers without `default_phone_region` being set in the config file
```

Run:

```bash
docker-compose -u www-data exec nextcloud php occ config:system:set default_phone_region --type string --value="FR"
```
