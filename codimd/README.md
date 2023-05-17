# codimd

https://github.com/hackmdio/codimd

A hackmd self hosted.

The best platform to write and share markdown. Sign In or Explore all features.
Real time collaboration. Works with charts and MathJax. Supports slide mode.

## Installation

To install codimd, follow these steps:

```bash
mkdir -p codimd/data codimd/db
chown -R 1500:1500 codimd/data
```

## User creation

```bash
$ docker-compose exec codimd ./bin/manage_users
You did not specify either --add or --del or --reset!

Command-line utility to create users for email-signin.
Usage: bin/manage_users [--pass password] (--add | --del) user-email
  Options:
    --add	Add user with the specified user-email
    --del	Delete user with specified user-email
    --reset	Reset user password with specified user-email
    --pass	Use password from cmdline rather than prompting
```
