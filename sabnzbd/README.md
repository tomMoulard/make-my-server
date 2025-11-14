# SABnzbd

Usenet (NZB) download client with auto-verification and extraction.

## Configuration

- **URL**: https://sabnzbd.${SITE}
- **Auth**: Basic auth via Traefik
- **Port**: 8080 (internal)

## Environment Variables

- `SABNZBD_IMAGE_VERSION`: Docker image version (default: latest)
- `SABNZBD_PUID`: User ID for file permissions (default: 1000)
- `SABNZBD_PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: Europe/Paris)

## Volumes

- `config/`: SABnzbd configuration and API keys
- `incomplete-downloads/`: Work-in-progress downloads
- `downloads/`: Completed downloads (SHARED with Radarr/Sonarr)

## Initial Setup

1. Access https://sabnzbd.${SITE}
2. Run setup wizard
3. Configure Usenet server (required: host, port, username, password)
4. Note API key from Config → General (needed for Radarr integration)

## Integration with Radarr

Radarr configuration:
- Host: `sabnzbd` (Docker service name)
- Port: `8080`
- API Key: From SABnzbd Config → General
- Category: `movies` (auto-created)

## Important Notes

- **Port 8080 may conflict** with other services on host (only internal port, Traefik handles routing)
- Downloads volume MUST be shared with Radarr for atomic moves (no file copying)
