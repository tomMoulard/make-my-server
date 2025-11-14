# Radarr

Automated movie collection manager for Usenet and torrents.

## Configuration

- **URL**: https://radarr.${SITE}
- **Auth**: Basic auth via Traefik
- **Port**: 7878 (internal)
- **API**: v3

## Environment Variables

- `RADARR_IMAGE_VERSION`: Docker image version (default: latest)
- `RADARR_PUID`: User ID for file permissions (default: 1000)
- `RADARR_PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: Europe/Paris)

## Volumes

- `config/`: Radarr database and configuration
- `downloads/`: Completed downloads from SABnzbd (SHARED)
- `movies/`: Organized movie library

## Initial Setup

1. Access https://radarr.${SITE}
2. Run setup wizard
3. Configure download client (SABnzbd):
   - Settings → Download Clients → Add → SABnzbd
   - Host: `sabnzbd`
   - Port: `8080`
   - API Key: From SABnzbd
   - Category: `movies`
4. Configure indexer (NZBHydra2):
   - Settings → Indexers → Add → Newznab
   - URL: `http://nzbhydra2:5076`
   - API Key: From NZBHydra2
5. Configure media management:
   - Settings → Media Management
   - Root Folder: `/movies`
   - File naming scheme
6. Note API key from Settings → General → Security (needed for Overseerr)

## Integration Points

- **Indexer**: NZBHydra2 (http://nzbhydra2:5076)
- **Download Client**: SABnzbd (http://sabnzbd:8080)
- **Media Library**: /movies
- **Request Interface**: Overseerr (http://overseerr:5055)
- **Subtitles**: Bazarr (existing, http://bazarr:6767)

## Shared Volume Pattern

**CRITICAL**: downloads/ volume MUST be same mount as SABnzbd for atomic moves:
- SABnzbd downloads to: /downloads/complete/movies/
- Radarr monitors: /downloads/complete/movies/
- Radarr moves to: /movies/Movie Name (Year)/
- No file copying = instant, no disk I/O
