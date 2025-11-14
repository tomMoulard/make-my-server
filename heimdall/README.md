# Heimdall

Heimdall is a dashboard for all your web applications. It provides a simple and clean interface to organize and access your self-hosted services.

## Features

- **Application Dashboard**: Organize your self-hosted services with customizable tiles
- **Enhanced Applications**: Built-in support for popular apps with automatic stats and information
- **Custom Links**: Add any application or URL to your dashboard
- **Tags and Search**: Organize apps with tags and quickly search through them
- **Multiple Themes**: Dark and light themes with custom color schemes
- **User Management**: Multi-user support with individual dashboards
- **API Integration**: Pull stats and information from supported applications
- **Responsive Design**: Works on desktop, tablet, and mobile devices

## Configuration

### Environment Variables

- `PUID`: User ID for file permissions (default: 1000)
- `PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: Europe/Paris)
- `HEIMDALL_IMAGE_VERSION`: Docker image version (default: latest)

### Volumes

- `./config`: Application configuration and database

### Access

Access Heimdall at: `https://heimdall.${SITE}`

Default credentials: No authentication required initially (protected by Traefik basic auth)

## Initial Setup

1. Access the dashboard through your configured domain
2. Click the "+" button to add applications
3. Choose from enhanced applications or add custom links
4. Configure application details:
   - **Title**: Display name
   - **URL**: Application address (use internal Docker service names like `http://radarr:7878`)
   - **Icon**: Choose from Font Awesome icons or upload custom
   - **Color**: Customize tile color
5. For enhanced applications, configure API settings to pull live stats
6. Organize applications using tags
7. (Optional) Create additional users under Settings → User Management

## Enhanced Application Examples

Heimdall has built-in support for many applications in your stack:

### Media Stack
- **Radarr**: `http://radarr:7878` - Shows movie count and upcoming
- **Sonarr**: `http://sonarr:8989` - Shows series count and upcoming
- **SABnzbd**: `http://sabnzbd:8080` - Shows queue and speed
- **NZBHydra2**: `http://nzbhydra2:5076` - Shows search stats
- **Overseerr**: `http://overseerr:5055` - Shows request counts

### Other Services
- **Nextcloud**: Shows storage usage
- **Traefik**: Dashboard access
- **Home Assistant**: Home automation status

## Tips

- Use internal Docker service names (e.g., `http://radarr:7878`) instead of external URLs
- Enable API access in your applications to see live stats on dashboard tiles
- Create tags like "Media", "Downloads", "Monitoring" to organize your apps
- Use the search bar (keyboard shortcut: /) to quickly find applications
- Customize the background under Settings → Interface
- Export your configuration regularly for backups

## Comparison with Homepage

Both Heimdall and Homepage are dashboard solutions with different approaches:

### Heimdall
- **UI Configuration**: All setup done through web interface
- **Database Storage**: SQLite database in `config/www/app.sqlite`
- **Enhanced Apps**: Built-in integrations for popular services
- **User Management**: Multi-user support
- **Mature**: Stable, well-established project

### Homepage
- **File Configuration**: YAML-based configuration
- **Docker Integration**: Native Docker socket integration for live stats
- **Modern UI**: Newer, more modern design aesthetic
- **Single User**: Designed for single-user/admin use
- **Active Development**: Rapidly evolving feature set

Choose based on your preference:
- **Heimdall**: If you prefer UI-based configuration and multi-user support
- **Homepage**: If you prefer YAML configuration and Docker-native features

## Troubleshooting

### Dashboard not loading
Check container logs:
```bash
docker-compose logs heimdall
```

### Application tiles not showing stats
1. Verify API access is enabled in the target application
2. Check API key/credentials are correct in Heimdall
3. Ensure you're using internal Docker service names
4. Check network connectivity: `docker-compose exec heimdall ping radarr`

### Permission issues
Ensure PUID/PGID match your user:
```bash
id
# Set in .env file: PUID=1000 PGID=1000
```

### Backup configuration
```bash
# Backup SQLite database
cp heimdall/config/www/app.sqlite heimdall_backup_$(date +%Y%m%d).sqlite

# Or backup entire config directory
tar -czf heimdall_config_backup.tar.gz heimdall/config/
```

## Documentation

- [Official Documentation](https://docs.linuxserver.io/images/docker-heimdall)
- [GitHub Repository](https://github.com/linuxserver/Heimdall)
- [LinuxServer.io Heimdall Image](https://github.com/linuxserver/docker-heimdall)
