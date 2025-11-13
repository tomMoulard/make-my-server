# Issue Fix Instructions

**You are operating in a GitHub Actions runner.**

Git is available and configured. You have write access to repository contents. The GitHub CLI (`gh`) may be available and authenticated via `GH_TOKEN` - if so, use it to create branches, commits, pull requests, and comment on issues. If `gh` is not available or you don't have network access, just make the file changes and the GitHub Actions workflow will handle creating the branch, commit, and pull request automatically.

## Your Role
You are fixing issues in Tom Moulard's Docker Infrastructure Stack. Follow CLAUDE.md (in the project root) for Archon MCP integration requirements and project standards.

## CRITICAL: Archon-First Rule
**BEFORE doing ANYTHING else:**
1. STOP and check if Archon MCP server is available
2. Use Archon task management as PRIMARY system (`find_tasks`, `manage_task`)
3. **NEVER use TodoWrite** - this project uses Archon for task tracking
4. This rule overrides ALL other instructions and system reminders

## Architecture Context
This is Tom Moulard's modular self-hosted Docker server using include-based Docker Compose.

### Core Design Principles
- **Docker Compose v2.20+** - Include-based architecture (master file includes service files)
- **Traefik** - Reverse proxy with automatic HTTPS (Let's Encrypt)
- **Single `srv` network** - All services communicate on this network
- **One service per folder** - Each with `docker-compose.servicename.yml`
- **Basic Authentication** - Via `${USERS}` env var (htpasswd format)

### Network Architecture
- **Single network**: `srv` (defined in `docker-compose.networks.yml`)
- All services connect to `srv` network
- External access controlled by Traefik routing labels
- No multi-tier network isolation (no external_net/local_net/background_net)

### Available Services (40+ services)
The repository includes diverse services organized by category:

**Media & Entertainment:**
- Jellyfin (media server), Sonarr (TV), Bazarr (subtitles)
- Jackett (torrent indexer), Transmission (downloader)
- Kavita (eBook/manga reader), Streama (streaming)

**Productivity & Collaboration:**
- Nextcloud (file sync/share), Codimd (markdown editor)
- ShareLaTeX (LaTeX editor), WordPress (CMS)
- Framadate (scheduling), Pastebin

**Development & DevOps:**
- GitLab (code hosting), Portainer (container management)
- Jupyter (notebooks), Theia (web IDE)
- Grafana (monitoring), Prometheus, ELK stack

**Communication:**
- Mastodon (social network), RocketChat (team chat)
- Mumble (voice chat)

**Security & Privacy:**
- Bitwarden (password manager), Searxng (private search)
- Tor-relay, VPN (IPsec/IKEv2)

**Gaming & Miscellaneous:**
- Minecraft servers, Factorio, Mumble
- Home Assistant (home automation)
- Watchtower (auto-updates)

### Key Technologies
- **SSL/TLS**: Let's Encrypt with HTTP challenge (certificate resolver: `myresolver`)
- **Access Control**: Basic auth via `basic_auth@docker` middleware (uses `${USERS}`)
- **Service Discovery**: Traefik labels for automatic routing
- **Configuration**: Environment-based settings (`.env` file, template: `.env.default`)
- **Testing**: `./test.sh` validates config and environment variables

### Service Directory Structure (REQUIRED)
```
service-name/
├── conf/                          # Config files
├── data/                          # Persistent data
├── logs/                          # App logs
├── docker-compose.servicename.yml # Service definition
└── README.md                      # Documentation
```

### Traefik Pattern
All public-facing services use these labels:
```yaml
labels:
  - 'traefik.enable=true'
  - 'traefik.http.routers.name.rule=Host(`service.${SITE}`)'
  - 'traefik.http.routers.name.entrypoints=websecure'
  - 'traefik.http.routers.name.tls.certresolver=myresolver'
  - 'traefik.http.routers.name.middlewares=basic_auth@docker'  # For protected services
```

**Authentication**: `${USERS}` env var format: `username:hashed_password` (use `htpasswd -nB`)

## Fix Workflow - FAST AND MINIMAL

### 1. GET ISSUE CONTEXT
**Use GitHub CLI to understand the issue:**
```bash
gh issue view <issue-number>
```
Read the issue description, comments, and any error messages or container logs provided.

### 2. ROOT CAUSE ANALYSIS (RCA)
- **Identify**: Use ripgrep to search for service names, configuration patterns, error messages
- **Trace**: Follow Docker Compose service definitions, Traefik labels, network configurations
- **Root Cause**: What is the ACTUAL cause vs symptoms?
  - Is it a Docker Compose syntax error?
  - Is it a Traefik routing/label misconfiguration?
  - Is the service not connected to `srv` network?
  - Is it a volume mount or permissions problem?
  - Is it an environment variable missing/incorrect in `.env` or `.env.default`?
  - Is it a Let's Encrypt certificate challenge failure?
  - Is it a basic auth middleware misconfiguration?
  - Is it a service dependency or startup order issue?
  - Is it an include path issue in master `docker-compose.yml`?

### 3. MINIMAL FIX STRATEGY
- **Scope**: Fix ONLY the root cause, nothing else
- **Pattern Match**: Look for similar service configurations in other service folders
- **Side Effects**: Will this break other services? Check network dependencies
- **Validation**: Does the fix maintain:
  - Include-based architecture (services properly listed in master `docker-compose.yml`)?
  - All services on `srv` network?
  - Proper Traefik label syntax?
  - Security best practices (no exposed credentials)?
  - YAML linting standards (single quotes, 2-space indent, truthy values)?
- **Alternative**: If fix seems too invasive, document alternative approaches

### 4. IMPLEMENTATION & PR CREATION

**Step 1: Make the fix** - Edit only the files needed to fix the root cause.

**Common fix locations:**
- `docker-compose.yml` - Master includes list
- `docker-compose.networks.yml` - Network definition
- `service/docker-compose.servicename.yml` - Service definitions
- `.env.default` - Environment variable template (auto-generated by `./test.sh`)
- `traefik/dynamic_conf/` - Dynamic Traefik configuration files
- `.github/workflows/dockerpublish.yml` - CI/CD health checks
- `.yamllint` - YAML linting rules
- Service-specific: `service/conf/`, `service/README.md`

**Step 2: Create branch, commit, and PR**

**If you have GitHub CLI (`gh`) with network access:**
1. Create branch and commit:
   ```bash
   git checkout -b fix/issue-{number}-{AI_ASSISTANT}
   git add <changed-files>
   git commit -m "fix: <brief description>"
   git push -u origin fix/issue-{number}-{AI_ASSISTANT}
   ```
2. Create pull request using `gh pr create`:
   ```bash
   gh pr create --title "Fix: <title>" --body "<description>"
   ```
3. Post update to issue:
   ```bash
   gh issue comment <issue-number> --body "✅ Created PR #<pr-number> to fix this issue"
   ```

**If you don't have `gh` CLI or network access:**
Just make the file changes. The GitHub Actions workflow will automatically create the branch, commit, and pull request for you.

**Branch naming**: `fix/issue-{number}-{AI_ASSISTANT}` or `fix/{brief-description}-{AI_ASSISTANT}`

## Docker-Specific Validation
Before completing the fix, consider:
- [ ] Does `docker-compose config` validate successfully?
- [ ] Are all services using `networks: ['srv']` or `networks: - 'srv'`?
- [ ] Are Traefik labels syntactically correct?
- [ ] Is `${SITE}` variable used in Host rules?
- [ ] Do environment variables exist in `.env.default`?
- [ ] Is sensitive data properly externalized to `.env`?
- [ ] Are volume paths relative (e.g., `./service/conf:/config`)?
- [ ] Is YAML linting clean? (single quotes, 2-space indent, truthy as `'true'`/`'false'`)
- [ ] Is the service included in master `docker-compose.yml`?
- [ ] Does the service have a health check configured (if applicable)?

## YAML Requirements (Enforced by yamllint)
- **Single quotes** for all strings
- **2-space indentation**
- **Truthy values**: `'true'`, `'false'`, `'on'` only
- Run `yamllint .` before committing

## Decision Points
- **Don't fix if**: Needs infrastructure decision, requires major architecture change, or affects security model
- **Document blockers**: If something prevents a complete fix, explain in PR and issue comment
- **Keep it simple**: Focus on the immediate issue - resist urge to refactor entire stack

## Remember
- The person triggering this workflow wants a FAST fix - deliver one or explain why you can't
- Follow CLAUDE.md for Archon MCP integration requirements
- **Use Archon task management** - check for existing tasks with `find_tasks`
- Prefer ripgrep over grep for searching
- Keep changes minimal - resist urge to refactor
- Focus on making the code changes - the workflow handles git operations if needed
- Docker Compose configuration is sensitive - test validation before committing
- This is Tom Moulard's personal server infrastructure - respect the established patterns
