# Mastodon

## Installing
To setup database, run this:
```bash
docker-compose run mastodon rails db:migrate
docker-compose run mastodon rails assets:precompile
```

## Setup
To setup, change ./mastodon/.env.production
```bash
docker-compose run mastodon rake secret
docker-compose run mastodon rake mastodon:webpush:generate_vapid_key
```
