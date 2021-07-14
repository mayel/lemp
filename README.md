# PHP / LEMP


Coöp Cloud + [PHP](https://php.org) + MariaDB + Nginx = 🥳

<!-- metadata -->

- **Category**: Apps
- **Status**: ❶💚
- **Image**: [`php`](https://hub.docker.com/_/php), ❶💚, upstream
- **Healthcheck**: Yes
- **Backups**: Yes
- **Email**: ❶💚
- **Tests**: ❷💛
- **SSO**: No

<!-- endmetadata -->

## Basic usage

1. Set up Docker Swarm and [`abra`][abra]
2. Deploy [`coop-cloud/traefik`][cc-traefik]
3. `abra app new lemp --secrets` (optionally with `--pass` if you'd like
   to save secrets in `pass`)
4. `abra app YOURAPPDOMAIN config` - be sure to change `$DOMAIN` to something that resolves to
   your Docker swarm box
5. `abra app YOURAPPDOMAIN deploy`
6. Copy your site files using something like: `abra app YOURAPPDOMAIN cp index.html app:/var/www/html/` or if you want to copy an entire directory: `tar cf - ./mysite | abra app YOURAPPDOMAIN cp - app:/var/www/html/`
6. Use [restore functionality](https://docs.coopcloud.tech/backup-restore/) to import a SQL file into the db
6. Open the configured domain in your browser to check all is good


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
