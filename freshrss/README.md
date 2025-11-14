# FreshRSS

Self-hosted RSS aggregator and reader.

## Configuration

- **URL**: https://freshrss.${SITE}
- **Auth**: Basic auth via Traefik
- **Port**: 80 (internal)

## Environment Variables

- `FRESHRSS_IMAGE_VERSION`: Docker image version (default: latest)
- `FRESHRSS_PUID`: User ID for file permissions (default: 1000)
- `FRESHRSS_PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: Europe/Paris)

## Volumes

- `data/`: FreshRSS configuration, feeds, and database

## Initial Setup

1. Access https://freshrss.${SITE}
2. Follow setup wizard
3. Create admin account

## Integration with FiveFilters (Optional)

To use full-text extraction:
1. Configure feed filter in FreshRSS
2. URL pattern: `http://fivefilters-full-text-rss:80/makefulltextfeed.php?url=%s`
