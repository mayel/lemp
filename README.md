# Wordpress

[![Build Status](https://drone.autonomic.zone/api/badges/coop-cloud/wordpress/status.svg)](https://drone.autonomic.zone/coop-cloud/wordpress)

Coöp Cloud + [Wordpress](https://wordpress.org) = 🥳

<!-- metadata -->

- **Category**: Apps
- **Status**: ❶💚
- **Image**: [`wordpress`](https://hub.docker.com/_/wordpress), ❶💚, upstream
- **Healthcheck**: Yes
- **Backups**: Yes
- **Email**: ❶💚
- **Tests**: ❷💛
- **SSO**: No

<!-- endmetadata -->

## Basic usage

1. Set up Docker Swarm and [`abra`][abra]
2. Deploy [`coop-cloud/traefik`][cc-traefik]
3. `abra app new wordpress --secrets` (optionally with `--pass` if you'd like
   to save secrets in `pass`)
4. `abra app YOURAPPDOMAIN config` - be sure to change `$DOMAIN` to something that resolves to
   your Docker swarm box
5. `abra app YOURAPPDOMAIN deploy`
6. Open the configured domain in your browser to finish set-up
7. `abra app YOURAPPDOMAIN run app chown www-data:www-data /var/www/html/wp-content` to fix
   file permissions (see #3)

## Running WP-CLI

`abra app YOURAPPDOMAIN wp 'core check-update --major'`

(the WP-CLI arguments need to be quoted, because of how `abra` handles
command-line arguments)

## Network (Multi-site)

_(Only tested using subdomains)_

1. Set up as above
2. `abra app YOURAPPDOMAIN config`, and uncomment the first `# Multisite` section
3. `abra app YOURAPPDOMAIN deploy`
4. Log into the Wordpress admin dashboard, go to Tools » Network Setup
5. Don't worry about the suggested file changes
6. `abra app YOURAPPDOMAIN config` again - comment out the first `# Multisite`
   section in `.envrc`, uncomment the `# Multisite phase 2` section, and add
   your multisite subdomain(s) to `EXTRA_DOMAINS` (beware the weird syntax..)
7. `abra app YOURAPPDOMAIN deploy`

## Installing a custom theme

`abra app YOURAPPDOMAIN cp ~/path/to/local/theme wordpress:/var/www/html/wp-content/themes/`

## Email

There is a local or remote SMTP relay configuration available.

- **local**: `COMPOSE_FILE=compose.yml:compose.mailrelay.yml`
- **remote**: `COMPOSE_FILE=compose.yml:compose.mailrelay.yml:compose.smtp.yml`

Below are the instructions for the local relay.

1. Deploy [`postfix-relay`][cc-postfix-relay]
2. `abra app YOURAPPDOMAIN config`, and uncomment the email lines; change
   `MAIL_FROM` to make sure the domain is the same as `postfix-relay`'s
   `$DOMAIN` or in its `$EXTRA_SENDER_DOMAINS`
3. `abra app YOURAPPDOMAIN deploy`

[abra]: https://git.autonomic.zone/autonomic-cooperative/abra
[cc-traefik]: https://git.autonomic.zone/coop-cloud/traefik
[cc-postfix-relay]: https://git.autonomic.zone/coop-cloud/traefik
