# FiveFilters Full-Text RSS

Full-Text RSS extracts article content from partial RSS feeds.

## Configuration

- **URL**: https://fivefilters.${SITE}
- **Auth**: Basic auth via Traefik
- **Port**: 80 (internal)

## Usage

Convert partial feed to full-text:
```
https://fivefilters.${SITE}/makefulltextfeed.php?url=FEED_URL
```

## Environment Variables

- `FIVEFILTERS_IMAGE_VERSION`: Docker image version (default: latest)
- `FIVEFILTERS_ADMIN_PASSWORD`: Optional admin panel password (leave empty to disable)

## Volumes

- `cache/`: RSS feed cache storage

## Integration with FreshRSS

Configure in FreshRSS feed settings:
```
http://fivefilters-full-text-rss:80/makefulltextfeed.php?url=%s
```
