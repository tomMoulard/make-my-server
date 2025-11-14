# Homepage

Modern, customizable application dashboard (alternative to Heimdall for evaluation).

## Configuration

- **URL**: https://homepage.${SITE}
- **Auth**: Basic auth via Traefik
- **Port**: 3000 (internal)

## Environment Variables

- `HOMEPAGE_IMAGE_VERSION`: Docker image version (default: latest)
- `HOMEPAGE_PUID`: User ID for file permissions (default: 1000)
- `HOMEPAGE_PGID`: Group ID for file permissions (default: 1000)
- `HOMEPAGE_ALLOWED_HOSTS`: Permitted hostnames (default: homepage.${SITE})

## Volumes

- `config/`: YAML configuration files (services.yaml, bookmarks.yaml, settings.yaml)
- `/var/run/docker.sock`: Docker integration (read-only, optional for auto-discovery)

## Initial Setup

1. Access https://homepage.${SITE}
2. Configure via YAML files in config/ directory
3. Reference: https://gethomepage.dev/configs/

## Configuration Files

Create these in `config/`:
- `settings.yaml`: Title, background, UI options
- `services.yaml`: Service definitions with URLs
- `bookmarks.yaml`: Organized bookmarks
- `widgets.yaml`: Widget configurations (optional)

## Comparison with Heimdall

- **Homepage**: File-based YAML config, modern Node.js stack, native Docker integration
- **Heimdall**: UI-based config, Laravel/PHP stack, SQLite database
