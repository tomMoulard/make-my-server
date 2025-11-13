# Corrections Applied to GitHub AI Assistant Prompts

## Date: 2025-11-14

## Summary
The prompt templates were copied from a different Docker infrastructure project and contained **significant architectural mismatches**. This document summarizes the corrections made to align them with Tom Moulard's make-my-server repository.

---

## Critical Issues Fixed

### 1. Network Architecture (CRITICAL)
**Was:** Three-tier network (external_net, local_net, background_net)
**Now:** Single `srv` network for all services

**Impact:** Claude would have given completely wrong advice about network configuration, potentially breaking services or creating security issues.

### 2. Authentication System (CRITICAL)
**Was:** Authelia SSO with TOTP 2FA
**Now:** Basic authentication via `${USERS}` environment variable (htpasswd format)

**Impact:** Claude would have referenced non-existent Authelia middleware, causing configuration errors.

### 3. Certificate Resolver (IMPORTANT)
**Was:** `letsencrypt`
**Now:** `myresolver`

**Impact:** Claude would have used wrong certificate resolver name, breaking SSL/TLS configuration.

### 4. Service Categories (IMPORTANT)
**Was:** Docker Compose profiles (media, rss, automation, network)
**Now:** No profiles - simple include-based architecture

**Impact:** Claude would have tried to use non-existent profile features.

### 5. Available Services (IMPORTANT)
**Was:** n8n, Overseerr, Sonarr, Radarr, FreshRSS, Twingate, SABnzbd, etc.
**Now:** Accurate list of 40+ services from `docker-compose.yml` includes

**Impact:** Claude would reference services that don't exist and miss services that do exist.

---

## Files Updated

### 1. `.github/prompts/docker_fix_prompt.md`
**Changes:**
- ✅ Architecture Context (lines 17-92): Complete rewrite
  - Single `srv` network architecture
  - Basic auth instead of Authelia
  - Accurate service list (40+ services organized by category)
  - Certificate resolver: `myresolver`
  - No Docker Compose profiles

- ✅ Root Cause Analysis (lines 103-115): Updated troubleshooting questions
  - References to `srv` network only
  - Basic auth middleware issues
  - Include path issues in master compose file

- ✅ Common Fix Locations (lines 133-141): Corrected file paths
  - `docker-compose.yml` (master includes)
  - `docker-compose.networks.yml` (network definition)
  - `.env.default` (not example.env)
  - `traefik/dynamic_conf/` (correct path)

- ✅ Validation Checklist (lines 168-178): Updated for this repo
  - Check `srv` network usage
  - Check `${SITE}` variable
  - Check `.env.default` (not example.env)
  - YAML linting requirements

### 2. `.github/prompts/docker_review_prompt.md`
**Changes:**
- ✅ Architecture Context (lines 17-69): Complete rewrite (same as fix prompt)

- ✅ Docker Compose Standards (lines 99-110): Updated
  - Single `srv` network emphasis
  - No profile organization
  - Service naming and structure

- ✅ Traefik Configuration (lines 112-121): Updated
  - Certificate resolver: `myresolver`
  - Basic auth middleware: `basic_auth@docker`
  - No Authelia references

- ✅ Network Architecture (lines 123-131): Complete rewrite
  - Single network design
  - No multi-tier isolation
  - Basic auth for access control

- ✅ Environment Management (lines 133-141): Updated
  - `.env.default` (not example.env)
  - `${SITE}` and `${USERS}` variables

- ✅ YAML Linting Section (lines 154-159): Added
  - Single quotes requirement
  - 2-space indentation
  - Truthy values format

- ✅ Validation Checklist (lines 231-241): Updated
  - `srv` network validation
  - YAML linting validation

### 3. `.github/AI_ASSISTANTS.md`
**Changes:**
- ✅ Architecture-Specific Features section (lines 101-122): Updated
  - Corrected file paths to `prompts/` directory
  - Updated architecture descriptions
  - Removed Authelia references
  - Added YAML linting mentions
  - Updated certificate resolver

---

## What Was Kept Unchanged

### Workflow Files (No Changes Needed)
- `.github/workflows/claude-fix.yml` ✅
- `.github/workflows/claude-review.yml` ✅

**Reason:** These load prompts dynamically from markdown files, so fixing the prompts was sufficient.

### Other Files (Already Correct)
- `.github/pull_request_template.md` ✅ (Generic enough)
- `.github/prompts/IMPLEMENTATION_NOTES.md` ✅ (Reference documentation)
- `.github/prompts/README.md` ✅ (If exists - verify)

### Archon MCP Integration (Already Correct)
The "CRITICAL: Archon-First Rule" sections were already correct in both prompts and were preserved.

---

## Verification Checklist

Before using the AI assistants, verify:

- [x] Prompts reference `srv` network only
- [x] Prompts mention basic auth (`basic_auth@docker` middleware)
- [x] Prompts use certificate resolver `myresolver`
- [x] Prompts reference `.env.default` (not example.env)
- [x] Prompts list accurate services from this repo
- [x] Prompts mention YAML linting requirements
- [x] Prompts have no references to Authelia
- [x] Prompts have no references to external_net/local_net/background_net
- [x] Prompts have no references to Docker Compose profiles
- [x] Prompts have no references to n8n, Overseerr, Twingate, etc. (services not in this repo)

---

## Testing Recommendations

### 1. Test Fix Workflow
Create a test issue with a simple problem:
```
Title: Test Issue - Traefik Routing Not Working
Body: The jellyfin service is not accessible via traefik.jellyfin.example.com
```

Comment: `@claude-fix`

**Expected Behavior:**
- Claude should check the jellyfin service configuration
- Reference the `srv` network
- Check Traefik labels with `${SITE}` variable
- Look for `basic_auth@docker` middleware if needed
- Check certificate resolver `myresolver`

### 2. Test Review Workflow
Create a test PR that adds a new service with intentional issues:
- Wrong network name (not `srv`)
- Missing service in master `docker-compose.yml`
- Wrong certificate resolver
- Environment variables not in `.env.default`

Comment: `@claude-review`

**Expected Behavior:**
- Claude should catch all intentional issues
- Reference correct architecture patterns
- Suggest fixes using this repo's conventions

---

## Source of Original Prompts

The prompts were based on the PydanticAI-Research-Agent repository, which appears to use:
- A different Docker infrastructure setup
- Authelia for SSO
- Three-tier network design
- n8n, Overseerr, and other specific services
- Docker Compose profiles

**Lesson:** Always verify that copied templates match your actual infrastructure before deployment.

---

## Maintenance

When the repository architecture changes, update:
1. `CLAUDE.md` (project instructions)
2. `.github/prompts/docker_fix_prompt.md`
3. `.github/prompts/docker_review_prompt.md`
4. `.github/AI_ASSISTANTS.md`
5. This corrections document

Keep all architectural documentation synchronized to ensure Claude has accurate context.

---

**Corrections Applied By:** Claude Code (via user request)
**Verified By:** [Awaiting user testing]
**Status:** Ready for testing
