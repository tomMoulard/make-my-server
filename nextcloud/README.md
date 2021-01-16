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

## Upgrade
How to upgrade your Nextcloud instance:
```bash
docker-compose pull nextcloud
docker-compose stop nextcloud && docker-compose up -d nextcloud
docker-compose exec -u www-data nextcloud ./occ upgrade^C
```

To remove maintenance mode:
```bash
docker-compose exec -u www-data nextcloud php occ maintenance:mode --off
```
