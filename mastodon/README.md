# Mastodon

Mastodon is a free and open-source self-hosted social networking service. It
allows anyone to host their own server node in the network, and its various
separately operated user bases are federated across many different servers.
These nodes are referred to as "instances" by Mastodon users. These servers
are connected as a federated social network, allowing users from different
servers to interact with each other seamlessly. Mastodon is a part of the wider
Fediverse, allowing its users to also interact with users on different open
platforms that support the same protocol, such as PeerTube and Friendica.

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
