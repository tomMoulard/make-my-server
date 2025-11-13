# AI Assistant Instructions for make-my-server

Token-optimized guidance for AI coding assistants working with this Docker Compose server infrastructure.

## Archon MCP Integration

### Critical Rules
1. **ALWAYS use Archon MCP tools** (`find_tasks`, `manage_task`) for task tracking - NEVER TodoWrite
2. **Task-Driven Development**: Check tasks BEFORE implementing, mark "doing" → "review" → "done"
3. **Research First**: Use `rag_search_knowledge_base()` and `rag_search_code_examples()` with SHORT queries (2-5 keywords)

### Quick Workflow
```
# Check tasks
find_tasks(filter_by="status", filter_value="todo")

# Start work
manage_task("update", task_id="...", status="doing")

# Research
rag_search_knowledge_base(query="docker healthcheck", match_count=5)
rag_search_code_examples(query="traefik labels", match_count=3)

# Complete
manage_task("update", task_id="...", status="review")
```

### Query Best Practices
✅ GOOD: `"docker healthcheck"`, `"traefik routing"`, `"network isolation"`
❌ BAD: `"how to implement docker compose health checks with traefik labels"`

**Tips**: 2-5 keywords only, technical terms, no filler words

### Targeted Doc Search
```
# 1. Get sources
rag_get_available_sources()

# 2. Find source ID for specific docs (e.g., Traefik)

# 3. Search that source
rag_search_knowledge_base(query="middleware", source_id="src_xxx", match_count=5)
```

### Task Management
- **Feature projects**: Detailed tasks (30min-4hrs each)
- **Codebase projects**: Feature-level tasks
- **Status flow**: `todo → doing → review → done`
- **One task "doing" at a time**

---

## Project Overview

Modular self-hosted Docker server using:
- **Docker Compose v2.20+** - Include-based architecture
- **Traefik** - Reverse proxy with HTTPS/basic auth
- **Single `srv` network** - All services communicate here
- **One service per folder** - Each with `docker-compose.servicename.yml`

**Author**: Tom Moulard | **Community**: [Discord](https://discord.gg/zQV6m9Jk6Z) | **Ideas**: [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)

---

## Architecture

### Include-Based Composition
- Master `docker-compose.yml` includes service files via `include:` directive
- Enable/disable services by commenting includes
- Requires Docker Compose v2.20+

### Service Directory Structure (REQUIRED)
```
service-name/
├── conf/                          # Config files
├── data/                          # Persistent data
├── logs/                          # App logs
├── docker-compose.servicename.yml # Service definition
└── README.md                      # Documentation
```

### Network
- **srv** network (defined in `docker-compose.networks.yml`)
- All services connect to `srv`
- External access via Traefik routing

### Traefik Pattern
```yaml
labels:
  - 'traefik.enable=true'
  - 'traefik.http.routers.name.rule=Host(`service.${SITE}`)'
  - 'traefik.http.routers.name.entrypoints=websecure'
  - 'traefik.http.routers.name.tls.certresolver=letsencrypt'
  - 'traefik.http.routers.name.middlewares=auth'  # Add for auth
```

**Auth**: `${USERS}` env var = `username:hashed_password` (use `htpasswd -nB`)

---

## Development Rules

### Git & GitHub CLI (CRITICAL)

**Repository Context:**
- **Your fork**: `Oliver-Sheaky/make-my-server` (origin)
- **Upstream**: `tomMoulard/make-my-server` (upstream)

**BEFORE Creating Pull Requests:**
```bash
# ALWAYS verify the default repository
gh repo view --json nameWithOwner -q .nameWithOwner
# MUST output: Oliver-Sheaky/make-my-server

# If incorrect, set default:
gh repo set-default Oliver-Sheaky/make-my-server
```

**Creating Pull Requests:**
- **For your fork** (most common): `gh pr create --base master`
- **For upstream contributions** (rare): `gh pr create --repo tomMoulard/make-my-server --base master`

**Rule**: NEVER create a PR without first verifying `gh repo view` shows Oliver-Sheaky's fork.

### YAML Requirements (Enforced by yamllint)
- **Single quotes** for all strings
- **2-space indentation**
- **Truthy values**: `'true'`, `'false'`, `'on'` only
- Run `yamllint .` before committing

### Docker Compose Conventions
- Files named `docker-compose.servicename.yml`
- Relative paths: `./service/conf:/config`
- All services on `srv` network
- Env vars: `${VARIABLE}` and document in `.env.default`
- Include health checks

### Testing Before Commit
```bash
./test.sh       # Validates config, checks env vars, detects drift
yamllint .      # YAML linting
docker-compose config  # Syntax check
```

---

## Common Tasks

### Add Service
1. Create structure: `mkdir service-name && cd service-name && mkdir conf data logs`
2. Create `docker-compose.servicename.yml` with service definition
3. Add to master `docker-compose.yml` includes
4. Create `README.md`
5. Run `./test.sh` to auto-generate env vars in `.env.default`
6. Add health check to `.github/workflows/dockerpublish.yml`
7. Test: `docker-compose config && ./test.sh && docker-compose up -d service-name`

### Remove Service
1. Remove/comment include from `docker-compose.yml`
2. Remove health check from `.github/workflows/dockerpublish.yml`
3. Run `./test.sh` to update `test_config.yml`
4. Clean up: `docker-compose down service-name` + delete directory

### Integrate External Compose (e.g., Supabase)
1. Setup external project in separate directory
2. Add to external compose: `networks: srv: external: true`
3. Connect services to `srv` network
4. Include in master: `include: - '../external-project/docker-compose.yml'`
5. Add Traefik labels for external access
6. Test: `docker-compose config && docker-compose up -d`

### Environment Variables
- Use `${VAR}` in compose files
- Run `./test.sh` to auto-update `.env.default`
- Set passwords: `echo "USERS=$(htpasswd -nB $USER)" >> .env`

### Local Dev
```bash
# Edit /etc/hosts
127.0.0.1   service.moulard.org

# Start
SITE=moulard.org docker-compose up -d
# OR: cp .env.default .env && edit .env && docker-compose up -d
```

---

## Testing

### test.sh (Automated)
Tests 3 things:
1. Syntax: `docker-compose config -q`
2. Config consistency vs `test_config.yml`
3. Env vars documented in `.env.default`

**Outputs**: `log.log` (errors), `patch.patch` (fixes), updates `test_config.yml`/`.env.default`

### Manual
```bash
docker-compose config           # Syntax check
docker-compose up -d            # Start
docker-compose ps               # Status
docker-compose logs service     # Logs
```

---

## CI/CD

### dockerpublish.yml
**Triggers**: All PRs/pushes
**Jobs**:
- **Config-test**: Validates syntax, runs `./test.sh`, uploads artifacts on fail
- **Health-checks**: 12 services (codimd, homeassistant, jackett, kavita, nextcloud, nginx, searxng, sharelatex, streama, traefik, transmission, wordpress)
- **Lint**: Runs `yamllint`, GitHub-formatted output

### healthcheck.workflow.tmpl.yml
Reusable template: setups Docker Compose v2.20.2, caches layers, runs startup script, starts service, polls health, checks for file changes

### dependabot.yml
Weekly GitHub Actions updates

### Future Plans
Auto-test generation/updates when services added/removed

---

## Key Files

- `docker-compose.yml` - Master (includes list)
- `docker-compose.networks.yml` - Defines `srv` network
- `.env.default` - Template (committed, auto-generated by `./test.sh`)
- `.env` - Your secrets (gitignored)
- `test_config.yml` - Golden reference (detects drift)
- `.yamllint` - Linting rules
- `test.sh` - Automated test suite

---

## Troubleshooting

### Service Won't Start
```bash
docker-compose logs service-name
docker-compose config | grep service-name -A 20
sudo chown -R $USER:$USER ./service-name/
```

### Routing Not Working
```bash
# Check Traefik dashboard: https://traefik.${SITE}/dashboard/
docker-compose config | grep -A 30 service-name | grep traefik
docker-compose exec traefik ping service-name
# Test locally: echo "127.0.0.1 service.domain" | sudo tee -a /etc/hosts
```

### Test Failures
```bash
git diff test_config.yml  # Review changes
cat patch.patch           # See suggested fixes
# If intentional: git add test_config.yml .env.default && git commit
```

### YAML Lint Errors
Common issues:
- Unquoted strings → use `'single quotes'`
- Wrong indentation → use 2 spaces
- Boolean format → use `'true'`/`'false'`/`'on'`

### Env Vars Not Working
```bash
cat .env                              # Verify exists
docker-compose config | grep VAR_NAME # Check expansion
grep VAR_NAME .env.default            # Verify documented
# Ensure no spaces: VAR=value (not VAR = value)
```

---

## When to Ask

**Proceed independently**: Following established patterns, adding similar services
**Ask first**: Architectural changes, new patterns, security implications, breaking changes

**Goal**: Productive autonomy + infrastructure stability
