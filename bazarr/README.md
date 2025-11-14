# Bazarr

https://www.bazarr.media/

Bazarr is a companion application to Sonarr and Radarr that manages and downloads subtitles based on your requirements. It automatically searches, downloads, and organizes subtitles for your TV shows and movies.

## Features

- **Automatic Subtitle Management**: Download subtitles for TV shows and movies
- **Sonarr & Radarr Integration**: Seamlessly integrates with existing media managers
- **Multiple Providers**: Supports OpenSubtitles, Addic7ed, TVSubtitles, and more
- **Language Profiles**: Configure preferred languages and fallback options
- **Hearing Impaired Support**: Specify preferences for HI/non-HI subtitles
- **Upgrade Subtitles**: Automatically upgrade to better subtitle releases
- **Synchronization**: Sync subtitles to match audio/video timing
- **Manual Search**: Search and download subtitles manually when needed

## Configuration

### Environment Variables

- `PUID`: User ID for file permissions (default: 1000)
- `PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: Europe/Paris)
- `BAZARR_IMAGE_VERSION`: Docker image version (default: v1.2.2)

### Volumes

- `./config`: Application configuration and database
- `./movies`: Movie library path (shared with Radarr)
- `./tv`: TV series library path (shared with Sonarr)

### Access

Access Bazarr at: `https://bazarr.${SITE}`

## Initial Setup

1. Access the web interface through your configured domain
2. Complete the initial setup wizard
3. Configure authentication (Settings → General)
4. Set up subtitle providers (Settings → Providers)
5. Configure Sonarr and Radarr integration

## Media Stack Integration

Bazarr requires integration with both Sonarr (for TV shows) and Radarr (for movies) to function.

### Sonarr Integration (TV Shows)

Configure Sonarr connection:

1. Go to **Settings → Sonarr**
2. Click **Add Series**
3. Configure:
   - **Address**: `sonarr` (Docker service name)
   - **Port**: `8989`
   - **API Key**: Get from Sonarr (Settings → General → Security → API Key)
   - **Base URL**: Leave empty
   - **SSL**: Disabled (internal Docker communication)
4. Test connection
5. Configure sync settings:
   - **Episode File Sync**: Set sync interval (e.g., 60 minutes)
   - **Full Update**: Set full sync interval (e.g., daily)
6. Save

Bazarr will now:
- Monitor your TV library at `/tv`
- Automatically download subtitles for new episodes
- Upgrade subtitles based on your profiles

### Radarr Integration (Movies)

Configure Radarr connection:

1. Go to **Settings → Radarr**
2. Click **Add Movies**
3. Configure:
   - **Address**: `radarr` (Docker service name)
   - **Port**: `7878`
   - **API Key**: Get from Radarr (Settings → General → Security → API Key)
   - **Base URL**: Leave empty
   - **SSL**: Disabled (internal Docker communication)
4. Test connection
5. Configure sync settings:
   - **Movie File Sync**: Set sync interval (e.g., 60 minutes)
   - **Full Update**: Set full sync interval (e.g., daily)
6. Save

Bazarr will now:
- Monitor your movie library at `/movies`
- Automatically download subtitles for new movies
- Upgrade subtitles based on your profiles

## Subtitle Providers

Configure subtitle providers for downloading:

1. Go to **Settings → Providers**
2. Enable and configure providers:
   - **OpenSubtitles**: Free (requires account) or VIP
   - **Addic7ed**: TV show subtitles (requires account)
   - **Subdivx**: Spanish subtitles
   - **TVSubtitles**: TV show subtitles
   - **YIFY Subtitles**: Movie subtitles
3. Add API keys/credentials for each provider
4. Set provider priorities (drag to reorder)
5. Configure rate limiting to avoid bans

## Language Profiles

Set up language profiles to define subtitle preferences:

1. Go to **Settings → Languages**
2. Click **Add Language Profile**
3. Configure:
   - **Name**: Profile name (e.g., "English", "Multi-Language")
   - **Languages**: Select preferred languages
   - **Cutoff**: Language to stop searching at
   - **Must Contain/Must Not Contain**: Filter subtitles
   - **Hearing Impaired**: Prefer/Exclude/Don't Care
4. Save profile
5. Apply profile to series/movies in Bazarr

## Volume Organization

```
bazarr/
├── config/              # Bazarr configuration and database
├── movies/              # Movie library (SHARED with Radarr)
│   └── Movie Name (Year)/
│       ├── Movie.mkv
│       └── Movie.en.srt  # Downloaded subtitle
└── tv/                  # TV library (SHARED with Sonarr)
    └── Show Name (Year)/
        └── Season 01/
            ├── Show.S01E01.mkv
            └── Show.S01E01.en.srt  # Downloaded subtitle
```

**Important**: The `./movies` and `./tv` directories must match the paths used by Radarr and Sonarr respectively.

## Tips

- **Anti-Captcha**: Configure anti-captcha service for providers requiring captcha solving
- **Scheduler**: Set up automatic sync schedules (Settings → Scheduler)
- **Exclusions**: Exclude specific series/movies from subtitle downloads
- **Manual Search**: Use manual search when automatic downloads fail
- **Subtitle Upgrades**: Enable automatic upgrades for better subtitle releases
- **Embedded Subtitles**: Configure how to handle embedded subtitles
- **Backup**: Regularly backup the `./config` directory

## Troubleshooting

### Subtitles not downloading
1. Check provider credentials (Settings → Providers)
2. Verify Sonarr/Radarr connections (Settings → Sonarr/Radarr → Test)
3. Check language profiles are applied to series/movies
4. Review logs (System → Logs)
5. Ensure media files are in expected locations

### Connection to Sonarr/Radarr failed
1. Verify service names are correct (`sonarr`, `radarr`)
2. Check ports (Sonarr: 8989, Radarr: 7878)
3. Verify API keys are correct
4. Test network connectivity:
   ```bash
   docker-compose exec bazarr ping sonarr
   docker-compose exec bazarr ping radarr
   ```

### Permission errors
```bash
# Fix permissions
sudo chown -R 1000:1000 bazarr/

# Or match your user
id  # Get your PUID/PGID
# Update PUID/PGID in .env file
```

### Subtitle sync issues
1. Enable **FFmpeg** in Settings → General
2. Use **Subtitle Sync** feature to fix timing
3. Consider different subtitle releases
4. Use manual search for problematic files

### Provider rate limiting
1. Add more subtitle providers
2. Configure rate limiting delays (Settings → Providers)
3. Consider VIP/premium accounts for higher limits
4. Use anti-captcha service if available

## Documentation

- [Official Documentation](https://wiki.bazarr.media/)
- [Bazarr Website](https://www.bazarr.media/)
- [GitHub Repository](https://github.com/morpheus65535/bazarr)
- [LinuxServer.io Image](https://docs.linuxserver.io/images/docker-bazarr)
