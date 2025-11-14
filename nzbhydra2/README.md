# NZBHydra2

Meta-search aggregator for NZB indexers (Newznab-compatible).

## Configuration

- **URL**: https://nzbhydra2.${SITE}
- **Auth**: Basic auth via Traefik
- **Port**: 5076 (internal)
- **API**: Newznab-compatible

## Environment Variables

- `NZBHYDRA2_IMAGE_VERSION`: Docker image version (default: latest)
- `NZBHYDRA2_PUID`: User ID for file permissions (default: 1000)
- `NZBHYDRA2_PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: Europe/Paris)

## Volumes

- `config/`: NZBHydra2 configuration and indexer definitions
- `downloads/`: NZB file storage

## Initial Setup

1. Access https://nzbhydra2.${SITE}
2. Add indexers in Config → Indexers (e.g., NZBgeek, NZBFinder, etc.)
3. Test each indexer
4. Note API key from Config → Main (click "API?" button)

## Integration with Radarr

Radarr indexer configuration:
- Type: Newznab
- URL: `http://nzbhydra2:5076`
- API Key: From NZBHydra2 Config → Main
- Categories: 2000 (Movies), 2010-2090 (sub-categories)

## Integration with SABnzbd (Optional)

NZBHydra2 can send downloads directly to SABnzbd:
- Config → Downloading → Downloader
- URL: `http://sabnzbd:8080`
- API Key: From SABnzbd settings
