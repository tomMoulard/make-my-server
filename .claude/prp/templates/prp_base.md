---
name: "make-my-server PRP Template - Docker Compose Service Implementation"
description: "Token-optimized template for adding/modifying Docker Compose services"
---

## Goal

**Feature**: [Specific service or integration to add/modify]

**Deliverable**: [Service directory with docker-compose file, or configuration change]

**Success**: [Service running, health check passing, accessible via Traefik]

## Why

- [Business/personal value of this service]
- [How it integrates with existing stack]
- [Problem it solves]

## What

### Success Criteria

- [ ] Service starts successfully via `docker-compose up -d`
- [ ] Health check passes (if applicable)
- [ ] Accessible via Traefik routing (if external access needed)
- [ ] All tests pass (`./test.sh`, `yamllint`)
- [ ] [Additional feature-specific criteria]

## Context

### Documentation & References

```yaml
# Service-specific docs
- url: [Official service documentation]
  why: [Configuration patterns, environment variables]

- url: [Docker Hub image page]
  why: [Image tags, volumes, environment variables]

# Repository patterns to follow
- file: [similar-service/docker-compose.servicename.yml]
  why: [Pattern for service structure, labels, networks]

- file: [.github/workflows/dockerpublish.yml]
  why: [Health check pattern for CI/CD]
```

### Current Repository Structure

```bash
# Run: tree -L 2 -I 'data|logs|conf' (or ls -la for quick view)
# Paste output here to show current services
```

### Desired Structure After Implementation

```bash
service-name/
├── conf/                          # Service configuration
├── data/                          # Persistent data
├── logs/                          # Application logs
├── docker-compose.servicename.yml # Service definition
└── README.md                      # Service documentation
```

### Known Gotchas

```yaml
# YAML Requirements (yamllint enforced)
- Single quotes for ALL strings
- 2-space indentation only
- Truthy values: 'true', 'false', 'on' (quoted)

# Docker Compose Patterns
- All services MUST connect to 'srv' network
- Use relative paths: './service-name/conf:/config'
- Environment variables: ${VAR} and document in .env.default

# Traefik Routing
- Labels required: traefik.enable, routers.rule, entrypoints, tls.certresolver
- Auth middleware: add 'middlewares=auth' label for basic auth
- Local dev: add '|| Host(`service.localhost`)' to rule

# Service-Specific Gotchas
# [Add any known issues with this specific service/image]
```

## Implementation Blueprint

### Task 1: Create Service Directory Structure

```bash
mkdir service-name
cd service-name
mkdir conf data logs
```

### Task 2: Create docker-compose.servicename.yml

```yaml
services:
  service-name:
    image: 'vendor/image:tag'
    container_name: 'service-name'
    restart: 'unless-stopped'
    networks:
      - 'srv'
    volumes:
      - './service-name/conf:/config'
      - './service-name/data:/data'
      - './service-name/logs:/logs'
    environment:
      - 'PUID=${PUID}'
      - 'PGID=${PGID}'
      - 'TZ=${TZ}'
      # Add service-specific env vars
    labels:
      - 'traefik.enable=true'
      - 'traefik.http.routers.service-name.rule=Host(`service.${SITE}`)'
      - 'traefik.http.routers.service-name.entrypoints=websecure'
      - 'traefik.http.routers.service-name.tls.certresolver=letsencrypt'
      - 'traefik.http.routers.service-name.middlewares=auth'  # Remove if public
      - 'traefik.http.services.service-name.loadbalancer.server.port=8080'  # Adjust port
    healthcheck:
      test: ['CMD', 'curl', '-f', 'http://localhost:8080/health']  # Adjust
      interval: '30s'
      timeout: '10s'
      retries: 3
      start_period: '60s'
```

### Task 3: Create service-name/README.md

```markdown
# Service Name

## Purpose
[What this service does]

## Configuration
- URL: https://service.${SITE}
- Auth: Basic auth via Traefik (username from .env)

## Environment Variables
- `SERVICE_VAR`: [Description] (default: value)

## Volumes
- `conf/`: [Configuration files]
- `data/`: [Persistent data]
- `logs/`: [Application logs]

## Notes
[Special setup steps, gotchas, known issues]
```

### Task 4: Add to docker-compose.yml

```yaml
include:
  # ... existing includes ...
  - 'service-name/docker-compose.servicename.yml'
```

### Task 5: Update Environment Variables

```bash
# Run test.sh to auto-generate new env vars
./test.sh

# Add default values to .env.default
# SERVICE_VAR=default_value
```

### Task 6: Add CI/CD Health Check (Optional)

Edit `.github/workflows/dockerpublish.yml`:

```yaml
Health-checks-service-name:
  uses: './.github/workflows/healthcheck.workflow.tmpl.yml'
  with:
    service_name: 'service-name'
    timeout-minutes: 5
    sus: |  # Startup script if needed
      mkdir -p service-name/conf
      touch service-name/conf/required-file
```

### Integration Points

```yaml
# If service needs external access
DNS:
  - Add A record: service.yourdomain.com → server IP

# If service needs database
DATABASE:
  - Create database/schema if needed
  - Add connection string to .env

# If service integrates with other services
NETWORKING:
  - Verify srv network connectivity
  - Add service-to-service communication patterns
```

## Validation Loop

### Level 1: YAML & Syntax Validation

```bash
# CRITICAL: Run before proceeding
yamllint service-name/docker-compose.servicename.yml
docker-compose config -q
./test.sh

# Expected: Zero errors. Fix all issues before continuing.
```

### Level 2: Service Startup Validation

```bash
# Start service
docker-compose up -d service-name

# Check status
docker-compose ps service-name

# View logs
docker-compose logs -f service-name

# Expected: Service state "Up" or "Up (healthy)"
```

### Level 3: Integration Testing

```bash
# Health check (if defined)
docker-compose exec service-name curl -f http://localhost:8080/health

# Network connectivity
docker-compose exec traefik ping service-name

# Traefik routing
curl -k https://service.${SITE}

# Local dev test (add to /etc/hosts first)
curl http://service.localhost

# Expected: Successful responses, no connection errors
```

### Level 4: Complete System Validation

```bash
# Full test suite
./test.sh
yamllint .
docker-compose config

# Restart all services
docker-compose restart

# Check all services
docker-compose ps

# Expected: All services healthy, no drift detected
```

## Final Validation Checklist

### Technical Validation

- [ ] All 4 validation levels pass
- [ ] `./test.sh` succeeds with no errors
- [ ] `yamllint .` reports zero issues
- [ ] `docker-compose config` completes without errors
- [ ] Service shows as "Up" or "Up (healthy)"

### Feature Validation

- [ ] All success criteria met
- [ ] Service accessible at expected URL
- [ ] Authentication working (if required)
- [ ] Data persists across restarts
- [ ] Logs are readable and informative

### Code Quality Validation

- [ ] Follows repository conventions:
  - Single quotes for all YAML strings
  - 2-space indentation
  - Connected to `srv` network
  - Proper healthcheck defined
  - Traefik labels follow pattern
- [ ] File structure matches template
- [ ] Environment variables documented in `.env.default`
- [ ] README.md created with service documentation
- [ ] CI/CD health check added (if applicable)

### Repository Integrity

- [ ] `test_config.yml` updated by `./test.sh`
- [ ] `.env.default` contains new variables
- [ ] No untracked volumes created (check `git status`)
- [ ] Service include added to `docker-compose.yml`

## Anti-Patterns to Avoid

- ❌ Don't use double quotes in YAML (use single quotes)
- ❌ Don't hardcode values (use `${ENV_VARS}`)
- ❌ Don't skip health checks (they're critical for CI/CD)
- ❌ Don't forget to connect to `srv` network
- ❌ Don't expose services without authentication
- ❌ Don't ignore `./test.sh` failures
- ❌ Don't use 4-space or tab indentation (2 spaces only)
- ❌ Don't commit `.env` file (only `.env.default`)
- ❌ Don't create new patterns when existing ones work
