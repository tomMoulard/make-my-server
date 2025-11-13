# Pull Request

## Summary
<!-- Provide a brief description of what this PR accomplishes -->

## Changes Made
<!-- List the main changes in this PR -->
-
-
-

## Type of Change
<!-- Mark the relevant option with an "x" -->
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] Infrastructure/configuration improvement
- [ ] Service update or addition

## Testing
<!-- Describe how you tested your changes -->
- [ ] Docker Compose configuration validates (`docker-compose config`)
- [ ] All affected services start successfully
- [ ] Traefik routing works correctly (if applicable)
- [ ] SSL certificates generate properly (if applicable)
- [ ] Service dependencies and networking verified

### Test Evidence
<!-- Provide specific test commands run and their results -->
```bash
# Example: docker-compose config
# Example: docker-compose up -d <service>
# Example: docker-compose logs <service>
# Example: curl -I https://service.yourdomain.com
```

## Infrastructure Impact
<!-- Mark areas affected by this change -->
- [ ] Docker Compose services
- [ ] Traefik routing/labels
- [ ] Network configuration (external_net, local_net, background_net)
- [ ] Environment variables (.env / example.env)
- [ ] Volume mounts or data paths
- [ ] Authelia authentication
- [ ] SSL/TLS certificates
- [ ] GitHub Actions workflows

## Checklist
<!-- Mark completed items with an "x" -->
- [ ] My changes follow Docker Compose and Traefik best practices
- [ ] If using an AI coding assistant, I followed the CLAUDE.md Archon rules
- [ ] I have tested the changes in a Docker environment
- [ ] All services start without errors
- [ ] Configuration files are syntactically valid
- [ ] I have updated example.env with any new variables
- [ ] I have updated relevant documentation
- [ ] No sensitive data (passwords, API keys) is committed

## Security Considerations
<!-- Address any security implications -->
- [ ] No new ports unnecessarily exposed
- [ ] Secrets properly externalized to .env
- [ ] Services assigned to correct network tier
- [ ] Authelia middleware applied to protected services (if needed)
- [ ] Docker socket access is read-only (if applicable)

## Breaking Changes
<!-- If this PR introduces breaking changes, describe them here -->
<!-- Include migration steps, required .env updates, or manual actions -->

## Additional Notes
<!-- Any additional information that reviewers should know -->
<!-- Screenshots, performance metrics, service dependencies, upgrade notes, etc. -->
