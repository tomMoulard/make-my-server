# AI Coding Assistants Integration

This repository integrates AI coding assistants into the GitHub workflow using GitHub Actions. These assistants can automatically fix issues, review pull requests, and generate release notes.

## Available Commands

### Issue Fixing: `@claude-fix`

Triggers Claude Code to analyze and fix reported issues.

**Usage:**
1. Create or comment on a GitHub Issue
2. Add comment: `@claude-fix`
3. Claude will:
   - Analyze the issue and codebase
   - Perform root cause analysis
   - Implement a fix
   - Comment back with a button to create a PR

**Example:**
```
Issue: Traefik routing broken for n8n service

Comment: @claude-fix
```

### Pull Request Review: `@claude-review`

Triggers Claude Code to perform a comprehensive code review.

**Usage:**
1. Create or comment on a Pull Request
2. Add comment: `@claude-review`
3. Claude will:
   - Analyze all changes
   - Review Docker Compose configuration
   - Check Traefik routing and security
   - Post detailed review with categorized issues

**Example:**
```
PR: Add new Jellyfin media server service

Comment: @claude-review
```

### Release Notes Generation

Automatically generates comprehensive release notes using Claude Code.

**Usage:**
1. Go to Actions tab → "AI-Generated Release Notes"
2. Click "Run workflow"
3. Enter tag name (e.g., `v1.2.0`)
4. Claude will:
   - Analyze commits and PRs since last release
   - Generate structured release notes
   - Create/update GitHub release
   - Comment on related PRs

## Setup Instructions

### 1. Configure Claude Code OAuth Token

Get your Claude Code OAuth token:
```bash
claude setup-token
```

Add the token to your repository secrets:
1. Go to repository Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Name: `CLAUDE_CODE_OAUTH_TOKEN`
4. Value: Paste your token
5. Click "Add secret"

### 2. Update Authorized Users (Optional)

By default, only `Oliver-Sheaky` can trigger the AI assistants. To change this:

Edit [claude-fix.yml](.github/workflows/claude-fix.yml) and [claude-review.yml](.github/workflows/claude-review.yml):

```yaml
# Change this line:
contains(fromJSON('["Oliver-Sheaky"]'), github.event.comment.user.login)

# To include your GitHub username(s):
contains(fromJSON('["your-username", "collaborator-username"]'), github.event.comment.user.login)
```

### 3. Cost Management

These workflows use your Claude Code subscription (same as CLI usage), not API credits. This is very cost-effective compared to API-based solutions.

**To prevent abuse:**
- Only authorized users can trigger workflows
- Fix workflow has 30-minute timeout
- Review workflow has 15-minute timeout
- Release notes workflow has 10-minute timeout

## Architecture-Specific Features

### Docker & Infrastructure Focus

The AI assistants are configured with Docker/infrastructure-specific knowledge:

**Fix Workflow** ([prompts/docker_fix_prompt.md](.github/prompts/docker_fix_prompt.md)):
- Docker Compose configuration validation (include-based architecture)
- Traefik routing and label syntax
- Single `srv` network architecture
- Basic authentication via htpasswd
- Let's Encrypt SSL/TLS with HTTP challenge (certificate resolver: `myresolver`)
- Environment variable management (`.env` and `.env.default`)
- YAML linting standards (single quotes, 2-space indent)

**Review Workflow** ([prompts/docker_review_prompt.md](.github/prompts/docker_review_prompt.md)):
- Docker Compose best practices (v2.20+ include-based)
- Single network design and service connectivity
- Traefik routing correctness
- Service dependency validation
- Configuration quality checks
- YAML linting enforcement

### Archon MCP Integration

These workflows respect the project's [CLAUDE.md](../CLAUDE.md) requirements:

- **Archon-First Rule**: Always check Archon MCP server availability
- Use Archon task management (`find_tasks`, `manage_task`)
- Never use TodoWrite tool (Archon is the task management system)

## Workflow Architecture

### Hybrid Approach (Claude Code)

**Issue Fix Flow:**
1. User creates issue and comments `@claude-fix`
2. GitHub Actions triggers workflow (security check)
3. Claude Code analyzes issue and codebase
4. Makes necessary code changes
5. Comments on issue with button to create PR
6. User reviews changes and creates PR

**Benefits:**
- Human remains in the loop
- Can iterate on fix before PR creation
- Full transparency of changes

### Read-Only Review

**PR Review Flow:**
1. User creates PR and comments `@claude-review`
2. GitHub Actions triggers workflow (security check)
3. Claude Code analyzes all changes
4. Posts comprehensive review comment
5. Human makes decisions on feedback

**Benefits:**
- Consistent review standards
- Catches common Docker/Traefik mistakes
- Security and best practice checks

## Troubleshooting

### "Not authorized" message

**Problem:** You commented `@claude-fix` or `@claude-review` but got an unauthorized message.

**Solution:** Add your GitHub username to the authorized users list (see Setup #2).

### Workflow doesn't trigger

**Problem:** You commented with the trigger phrase but nothing happened.

**Possible causes:**
1. Token not configured: Check `CLAUDE_CODE_OAUTH_TOKEN` secret exists
2. Token expired: Regenerate with `claude setup-token`
3. Typo in comment: Must be exactly `@claude-fix` or `@claude-review`

### Workflow times out

**Problem:** Workflow runs for 30 minutes then fails.

**Possible causes:**
1. Issue is too complex for autonomous fix
2. Codebase search taking too long
3. Claude stuck in analysis loop

**Solution:**
- Break issue into smaller, focused issues
- Provide more specific context in issue description
- Consider manual fix for complex architectural changes

### Docker commands fail in workflow

**Problem:** Claude tries to run `docker-compose` commands but they fail.

**Note:** This is expected - the GitHub Actions runner doesn't have access to your Docker services. The workflows are designed for code changes only, not runtime testing.

## Customization

### Modify Prompts

Edit the prompt templates to customize AI behavior:
- [docker_fix_prompt.md](.github/docker_fix_prompt.md) - Fix instructions
- [docker_review_prompt.md](.github/docker_review_prompt.md) - Review criteria

### Adjust Allowed Tools

Edit workflow YAML files to change what tools Claude can use:

**Fix workflow** - Write access:
```yaml
allowed_tools: "Edit(*),Write(*),Read(*),Grep(*),Glob(*),Bash(git *)..."
```

**Review workflow** - Read-only:
```yaml
allowed_tools: "Read(*),Grep(*),Glob(*),Bash(git log*)..."
```

### Extend to Other AI Assistants

The video tutorial this is based on shows how to add:
- **Codex** (OpenAI) - Requires API key, more autonomous
- **Cursor** - Requires API key, fully autonomous

See [YouTube tutorial](https://www.youtube.com/watch?v=...) for details.

We chose **Claude Code only** because:
- Production-ready GitHub Action
- Uses subscription (cost-effective)
- Hybrid approach (human in the loop)
- Best for infrastructure code

## Security Notes

### Secret Management

- `CLAUDE_CODE_OAUTH_TOKEN`: Stored in GitHub Secrets, never exposed in logs
- `GITHUB_TOKEN`: Automatically provided by GitHub Actions, scoped to repository

### Permissions

**Fix workflow:**
- `contents: write` - Create branches, edit files
- `pull-requests: write` - Create PRs, comment
- `issues: write` - Comment on issues

**Review workflow:**
- `contents: read` - Read-only access
- `pull-requests: write` - Post review comments
- `issues: write` - Post comments

### Access Control

Only specified users can trigger workflows. Unauthorized attempts are logged and result in a public comment.

## Additional Resources

- [Claude Code Documentation](https://docs.anthropic.com/claude-code)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Docker Compose Best Practices](https://docs.docker.com/compose/production/)
- [Traefik Documentation](https://doc.traefik.io/traefik/)

## Support

If you encounter issues with the AI assistant workflows:

1. Check [Troubleshooting](#troubleshooting) section
2. Review workflow run logs in Actions tab
3. Create an issue with the `workflow` label
4. Include:
   - What command you ran
   - Link to the issue/PR
   - Workflow run URL
   - Error messages from logs
