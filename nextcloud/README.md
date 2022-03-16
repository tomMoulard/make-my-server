# nextcloud

http://nextcloud.com/

Nextcloud is a suite of client-server software for creating and using file
hosting services. Nextcloud is free and open-source, which means that anyone is
allowed to install and operate it on their own private server devices.

With the integrated OnlyOffice, Nextcloud application functionally is similar
to Dropbox, Office 365 or Google Drive, but can be used on home-local computers
or for off-premises file storage hosting.

The original ownCloud developer Frank Karlitschek forked ownCloud and created
Nextcloud, which continues to be actively developed by Karlitschek and other
members of the original ownCloud team.

## Setup

### Cron

Ajax is the default, byt cron is the best

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

If you forgot to install nextcloud with its dedicated database, you can run this command to migrate from anything to the mariadb instance:
```
docker-compose exec -u www-data nextcloud php occ db:convert-type --all-apps --port 3306 --password nextcloud mysql nextcloud nextcloud-db nextcloud
```

## Upgrade
How to upgrade your Nextcloud instance:
```bash
docker-compose pull nextcloud
docker-compose stop nextcloud && docker-compose up -d nextcloud
docker-compose exec -u www-data nextcloud ./occ upgrade
```

To remove maintenance mode:
```bash
docker-compose exec -u www-data nextcloud php occ maintenance:mode --off
```

## Misc

### Re apply the coniguration

If you want to re apply the configuration of nextcloud, you can always run this:
```bash
docker-compose -u www-data exec nextcloud php occ maintenance:repair
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
