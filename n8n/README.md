# n8n

Workflow automation platform with SQLite backend.

## Configuration

- **URL**: https://n8n.${SITE}
- **Auth**: Basic auth via Traefik (N8N_BASIC_AUTH_ACTIVE=false)
- **Port**: 5678 (internal)
- **Database**: SQLite (stored in data/database.sqlite)

## Environment Variables

- `N8N_IMAGE_VERSION`: Docker image version (default: latest)
- `N8N_PROTOCOL`: https (for webhook URL generation)
- `N8N_HOST`: n8n.${SITE} (external hostname)
- `WEBHOOK_URL`: https://n8n.${SITE}/ (external webhook URL)
- `N8N_BASIC_AUTH_ACTIVE`: false (auth delegated to Traefik)
- `N8N_SECURE_COOKIE`: true (HTTPS-only cookies)
- `N8N_CORS_ORIGIN`: * (allow external webhooks)
- `DB_TYPE`: sqlite (no external database required)
- `TZ`: Timezone (default: Europe/Paris)

## Volumes

- `data/`: SQLite database, workflows, credentials, encryption keys

## Initial Setup

1. Access https://n8n.${SITE}
2. Create admin account
3. Configure workflows

## Backup

**CRITICAL**: Backup entire `data/` directory including:
- `database.sqlite`: Workflow definitions and execution history
- `.encryption-keys`: Credential encryption keys (required for restore)

## Migration to PostgreSQL (Future)

Consider migrating when:
- Execution volume > 10,000 per day
- Database size > 4-5GB
- Multiple concurrent users
