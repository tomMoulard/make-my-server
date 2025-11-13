# AI Workflow Prompts

This directory contains custom prompt templates for AI-powered GitHub workflows.

## Overview

The repository uses [Claude Code](https://claude.com/claude-code) for automated code review and issue fixing. These prompts customize Claude's behavior to understand Docker/infrastructure-specific best practices.

## Prompt Files

### docker_fix_prompt.md
**Used by:** `.github/workflows/claude-fix.yml`

**Purpose:** Guides Claude when autonomously fixing reported issues.

**Triggered by:** Commenting `@claude-fix` on a GitHub issue

**Focus Areas:**
- Docker Compose configuration validation
- Traefik routing and label syntax
- Network architecture (external_net, local_net, background_net)
- Authelia authentication setup
- Let's Encrypt SSL/TLS troubleshooting
- Environment variable management

### docker_review_prompt.md
**Used by:** `.github/workflows/claude-review.yml`

**Purpose:** Guides Claude when reviewing pull requests.

**Triggered by:** Commenting `@claude-review` on a pull request

**Focus Areas:**
- Docker Compose best practices
- Network security and isolation
- Traefik routing correctness
- Service dependency validation
- Configuration quality checks

### IMPLEMENTATION_NOTES.md
**Purpose:** Historical implementation notes and decisions

**Usage:** Reference for understanding past architectural choices

## Customization

You can modify these prompts to change how the AI assistants behave:

### Adding New Focus Areas

Edit the prompt files to add additional validation checks:

```markdown
## Additional Checks

- Verify backup volumes are properly configured
- Check for resource limits on containers
- Validate health check configurations
```

### Changing Tone/Style

Adjust the instruction style:

```markdown
# Strict Mode
- Flag ALL deviations from best practices
- Require explicit justification for unconventional patterns

# Lenient Mode
- Focus only on security issues
- Allow flexible implementation choices
```

### Project-Specific Rules

Add custom rules for your environment:

```markdown
## Project Rules

- All media services MUST use the media profile
- Traefik labels MUST follow the pattern: service-name-{http|https}
- Config paths MUST use ${CONFIG_ROOT} variable
```

## Workflow Integration

These prompts are automatically loaded by GitHub Actions workflows:

```yaml
# .github/workflows/claude-fix.yml
- name: Load fix instructions
  run: |
    INSTRUCTIONS=$(cat .github/prompts/docker_fix_prompt.md)
    echo "CUSTOM_INSTRUCTIONS=$INSTRUCTIONS" >> $GITHUB_OUTPUT

- name: Run Claude Code Fix
  uses: anthropics/claude-code-action@beta
  with:
    custom_instructions: ${{ steps.load-instructions.outputs.CUSTOM_INSTRUCTIONS }}
```

## Testing Prompts

To test prompt changes without committing:

1. **Local Testing:**
   ```bash
   # Copy prompt content and paste into Claude Code manually
   claude-code --instructions "$(cat .github/prompts/docker_fix_prompt.md)"
   ```

2. **Workflow Testing:**
   - Create a test issue or PR
   - Trigger the workflow with `@claude-fix` or `@claude-review`
   - Review the output for quality

3. **Iterative Refinement:**
   - If Claude misses issues: Add more specific instructions
   - If Claude is too strict: Add context/exceptions
   - If Claude is confused: Clarify terminology

## Best Practices

### Writing Effective Prompts

**DO:**
- Be specific about validation criteria
- Provide examples of good/bad patterns
- Explain the "why" behind rules
- Include platform-specific considerations (Windows/macOS/Linux)

**DON'T:**
- Make prompts too long (Claude has token limits)
- Contradict general best practices without explanation
- Assume Claude knows project-specific conventions

### Maintaining Prompts

- **Review Quarterly:** Update as project evolves
- **Document Changes:** Note why instructions were added/modified
- **Test Regularly:** Ensure AI behavior matches expectations
- **Keep Concise:** Remove outdated or redundant instructions

## Examples

### Example: Adding Security Check

**Before:**
```markdown
- Verify network configuration is correct
```

**After:**
```markdown
- Verify network configuration:
  - Public services ONLY on external_net
  - Internal services ONLY on local_net
  - Background services ONLY on background_net
  - Never expose Docker socket on external_net
```

### Example: Adding Platform Note

**Before:**
```markdown
- Check file permissions
```

**After:**
```markdown
- Check file permissions:
  - acme.json MUST be 600 (owner read/write only)
  - Windows: Use WSL for permission commands
  - macOS/Linux: Standard chmod applies
```

## Troubleshooting

### Claude Ignoring Instructions

**Problem:** Claude doesn't follow prompt guidelines

**Solutions:**
- Make instructions more explicit
- Add examples of expected behavior
- Use imperative language ("DO X" not "Consider X")
- Move critical rules to top of prompt

### Claude Too Strict

**Problem:** Claude flags acceptable patterns

**Solutions:**
- Add exceptions/context
- Explain when patterns are acceptable
- Provide alternative approaches

### Claude Missing Issues

**Problem:** Claude doesn't catch known problems

**Solutions:**
- Add specific validation checks
- Provide examples of the issue
- Explain why it's problematic

## Related Documentation

- [AI_ASSISTANTS.md](../AI_ASSISTANTS.md) - User guide for triggering workflows
- [CLAUDE.md](../../CLAUDE.md) - AI assistant instructions for the codebase
- [Claude Code Documentation](https://docs.anthropic.com/claude-code)

## Contributing

When adding new prompts:

1. Create prompt file in this directory
2. Update this README with description
3. Create corresponding workflow in `.github/workflows/`
4. Test with sample issue/PR
5. Document any special considerations

---

**Note:** These prompts are part of the public repository. They demonstrate transparency in how AI assists with code quality, and can serve as examples for others building similar workflows.
