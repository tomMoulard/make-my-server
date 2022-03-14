# Watchtower

https://containrrr.dev/watchtower/

A container-based solution for automating Docker container base image updates.

With watchtower you can update the running version of your containerized app
simply by pushing a new image to the Docker Hub or your own image registry.
Watchtower will pull down your new image, gracefully shut down your existing
container and restart it with the same options that were used when it was
deployed initially.
