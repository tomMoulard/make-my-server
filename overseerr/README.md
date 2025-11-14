# Overseerr

Media request and discovery tool for Radarr/Sonarr.

## Configuration

- **URL**: https://overseerr.${SITE}
- **Auth**: Basic auth via Traefik (Plex auth also required internally)
- **Port**: 5055 (internal)

## Environment Variables

- `OVERSEERR_IMAGE_VERSION`: Docker image version (default: latest)
- `OVERSEERR_PUID`: User ID for file permissions (default: 1000)
- `OVERSEERR_PGID`: Group ID for file permissions (default: 1000)
- `TZ`: Timezone (default: Europe/Paris)

## Volumes

- `config/`: Overseerr database and configuration

## Prerequisites

### Plex Media Server

**REQUIRED**: Overseerr uses Plex for user authentication and library management.

#### Native Windows Plex Setup (Recommended)

If you're running Plex natively on Windows (recommended for better transcoding performance):

1. **Ensure Plex is running** on your Windows host
2. **Find your server IP address**:
   ```cmd
   ipconfig
   ```
   Look for your local IP (e.g., `192.168.1.100`)

3. **Verify Plex is accessible** from Docker containers:
   - Plex default port: `32400`
   - Test URL: `http://YOUR_WINDOWS_IP:32400/web`
   - Ensure Windows Firewall allows port 32400

4. **Note your Plex credentials**:
   - Plex account email/username
   - Plex account password

#### Docker Plex Alternative (Optional)

If you prefer running Plex in Docker (adds complexity):
- Requires GPU passthrough for hardware transcoding
- Typically uses `network_mode: host` or port `32400` published
- More complex than native installation
- See Plex documentation for Docker setup

## Initial Setup

### Step 1: Connect to Overseerr

1. Access https://overseerr.${SITE}
2. Click "Use your Plex account" on the welcome screen

### Step 2: Configure Plex Connection

1. **Sign in with Plex**:
   - Enter your Plex account credentials
   - Overseerr will authenticate via Plex.tv

2. **Select your Plex server**:
   - If Plex is running natively on Windows:
     - Select your server from the dropdown
     - If not listed, manually enter: `http://YOUR_WINDOWS_IP:32400`
     - Example: `http://192.168.1.100:32400`
   - Click "Test" to verify connection
   - **Important**: Use the local IP address, NOT localhost or 127.0.0.1

3. **Select Plex Libraries**:
   - Choose which Plex libraries to sync (Movies, TV Shows)
   - These will be used to show what's already available

4. **Set Admin Account**:
   - Your Plex user will become the Overseerr admin
   - You can invite other Plex users later

### Step 3: Configure Radarr (Movies)

1. Go to **Settings → Services → Radarr**
2. Click **Add Server**
3. Configure:
   - **Default Server**: Enable (if this is your only Radarr)
   - **Server Name**: Radarr
   - **Hostname or IP**: `radarr` (Docker service name)
   - **Port**: `7878`
   - **Use SSL**: Disabled
   - **API Key**: Get from Radarr (Settings → General → Security → API Key)
   - **URL Base**: Leave empty
4. Click **Test** to verify connection
5. Select:
   - **Quality Profile**: Choose preferred quality (e.g., HD-1080p)
   - **Root Folder**: `/movies`
   - **Minimum Availability**: Select when to search (e.g., Released)
   - **Tags**: Optional tags for organization
6. **Enable Scan** and **Enable Automatic Search**
7. Click **Save Changes**

### Step 4: Configure Sonarr (TV Shows)

1. Go to **Settings → Services → Sonarr**
2. Click **Add Server**
3. Configure:
   - **Default Server**: Enable (if this is your only Sonarr)
   - **Server Name**: Sonarr
   - **Hostname or IP**: `sonarr` (Docker service name)
   - **Port**: `8989`
   - **Use SSL**: Disabled
   - **API Key**: Get from Sonarr (Settings → General → Security → API Key)
   - **URL Base**: Leave empty
4. Click **Test** to verify connection
5. Select:
   - **Quality Profile**: Choose preferred quality (e.g., HD-1080p)
   - **Root Folder**: `/tv`
   - **Language Profile**: Select language
   - **Tags**: Optional tags for organization
   - **Anime Quality Profile**: If you watch anime
   - **Anime Root Folder**: Optional separate anime folder
6. **Enable Scan** and **Enable Automatic Search**
7. **Season Folders**: Enable
8. Click **Save Changes**

### Step 5: Configure User Permissions

1. Go to **Settings → Users**
2. Configure default permissions for new users:
   - **Auto-Approve Movies**: Let users request movies without approval
   - **Auto-Approve Series**: Let users request TV shows without approval
   - **Request Limits**: Set how many requests per day/week/month
3. Invite additional Plex users:
   - They can sign in with their Plex accounts
   - You'll need to grant them access to your Plex server first

## User Workflow

1. User browses movies/TV in Overseerr
2. User requests media
3. Admin approves (or auto-approve configured)
4. Overseerr sends request to Radarr/Sonarr
5. Radarr/Sonarr searches, downloads, organizes
6. Media appears in Plex library

## Integration Points

- **Authentication**: Plex (external)
- **Movie Requests**: Radarr (http://radarr:7878)
- **TV Requests**: Sonarr (http://sonarr:8989, existing)
