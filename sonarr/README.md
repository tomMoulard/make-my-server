# Sonarr

https://sonarr.tv/

Sonarr is a PVR for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new episodes of your favorite shows and will grab, sort and rename them. It can also be configured to automatically upgrade the quality of files already downloaded when a better quality format becomes available.

## Features

- **Automatic TV Show Management**: Monitor, download, and organize TV series
- **Quality Profiles**: Define preferred quality and upgrade automatically
- **Calendar**: Track upcoming episodes and releases
- **Metadata & Artwork**: Download subtitles, artwork, and metadata
- **Integration**: Works with popular download clients and indexers
- **Notifications**: Get notified when episodes are downloaded
- **List Integration**: Import shows from Trakt, IMDb, and other lists

## Configuration

### Environment Variables

- `PUID`: User ID for file permissions (default: 1000)
- `PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: Europe/Paris)
- `SONARR_IMAGE_VERSION`: Docker image version (default: 4.0.0)

### Volumes

- `./config`: Application configuration and database
- `./downloads`: Shared downloads directory (must match SABnzbd)
- `./tv`: TV series library (final organized location)

### Access

Access Sonarr at: `https://sonarr.${SITE}`

## Initial Setup

1. Access the web interface through your configured domain
2. Complete the initial setup wizard
3. Configure authentication (Settings → General → Security)
4. Set up API key (generated automatically, found in Settings → General)

## Media Stack Integration

Sonarr integrates with other services in the media stack:

### SABnzbd (Download Client)

Configure SABnzbd as your download client:

1. Go to **Settings → Download Clients → Add → SABnzbd**
2. Configure:
   - **Name**: SABnzbd
   - **Host**: `sabnzbd` (Docker service name)
   - **Port**: `8080`
   - **API Key**: Get from SABnzbd (Settings → General → API Key)
   - **Category**: `tv` (creates separate category in SABnzbd)
3. Test connection and save

**Important**: The `./downloads` directory MUST be the same path in both Sonarr and SABnzbd for atomic moves/hardlinks to work.

### NZBHydra2 (Indexer Aggregator)

Configure NZBHydra2 as your indexer:

1. Go to **Settings → Indexers → Add → Newznab → Custom**
2. Configure:
   - **Name**: NZBHydra2
   - **URL**: `http://nzbhydra2:5076`
   - **API Key**: Get from NZBHydra2 (Config → Main)
   - **Categories**: Select TV categories (5000, 5030, 5040)
3. Test connection and save

Alternatively, you can add individual indexers directly to Sonarr, but NZBHydra2 provides a unified interface.

### Bazarr (Subtitles)

Bazarr automatically connects to Sonarr to download subtitles for your TV shows.

Configuration in Bazarr:
1. Go to **Settings → Sonarr**
2. Configure:
   - **Address**: `sonarr`
   - **Port**: `8989`
   - **API Key**: Get from Sonarr (Settings → General → Security)
   - **Base URL**: Leave empty
3. Test and save

### Overseerr (Request Management)

Overseerr allows users to request TV shows that Sonarr will automatically download.

Configuration in Overseerr:
1. Go to **Settings → Services → Sonarr**
2. Configure:
   - **Server Name**: Sonarr
   - **Hostname/IP**: `sonarr`
   - **Port**: `8989`
   - **API Key**: Get from Sonarr
   - **Root Folder**: `/tv`
   - **Quality Profile**: Select default profile
3. Test and save

## Volume Organization

```
sonarr/
├── config/          # Sonarr configuration and database
├── downloads/       # SHARED with SABnzbd (for atomic moves)
│   └── tv/         # SABnzbd category folder
└── tv/             # Final organized TV library
    ├── Show Name (Year)/
    │   └── Season 01/
    │       ├── Show.S01E01.mkv
    │       └── Show.S01E02.mkv
    └── ...
```

## Quality Profiles

Recommended quality profile setup:

1. Go to **Settings → Profiles**
2. Create or modify profiles:
   - **HD-1080p**: For high-quality releases
   - **HD-720p**: For moderate quality
   - **Any**: Accept any quality
3. Configure upgrade settings:
   - Enable **Upgrade Until** to automatically upgrade to better quality
   - Set cutoff quality (e.g., Bluray-1080p)

## Root Folders

Configure root folders for different types of content:

1. Go to **Settings → Media Management → Root Folders**
2. Add root folder: `/tv`
3. (Optional) Add additional folders for different libraries

## Tips

- Use **Series Type** to specify anime, daily shows, or standard series
- Enable **Season Folders** in Settings → Media Management
- Configure **File Naming** to your preferred format
- Set up **Import Lists** to automatically add shows from Trakt/IMDb
- Use **Tags** to apply different settings to different shows
- Enable **Recycle Bin** to safely delete files

## Troubleshooting

### Shows not downloading
1. Check indexer connections (Settings → Indexers → Test)
2. Verify SABnzbd is configured and connected
3. Check quality profile allows available releases
4. Review logs (System → Logs)

### Downloads not importing
1. Verify `./downloads` path matches between Sonarr and SABnzbd
2. Check file permissions (PUID/PGID)
3. Ensure SABnzbd category is set to `tv`
4. Check completed download handling (Settings → Download Clients)

### Permission errors
```bash
# Fix permissions
sudo chown -R 1000:1000 sonarr/

# Or match your user
id  # Get your PUID/PGID
# Update PUID/PGID in .env file
```

### API connection issues
- Verify internal service names are used (`sabnzbd`, not `sabnzbd.domain.com`)
- Check all services are on the `srv` network
- Test connectivity: `docker-compose exec sonarr ping sabnzbd`

## Documentation

- [Official Documentation](https://wiki.servarr.com/sonarr)
- [Sonarr Website](https://sonarr.tv/)
- [LinuxServer.io Image](https://docs.linuxserver.io/images/docker-sonarr)
