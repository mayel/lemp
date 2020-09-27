# wordpress

[![Build Status](https://drone.autonomic.zone/api/badges/compose-stacks/wordpress/status.svg)](https://drone.autonomic.zone/compose-stacks/wordpress)

Coöp Cloud + [Wordpress](https://wordpress.org) = 🥳

1. Set up Docker Swarm and [`abra`][abra]
2. Deploy [`compose-stacks/traefik`][compose-traefik]
3. `cp .envrc.sample .envrc`
4. Edit `.envrc` - be sure to change `$DOMAIN` to something that resolves to
   your Docker swarm box
5. `direnv allow` (or `. .envrc`)
6. Generate secrets:
   ```
   abra secret_generate db_password v1
   abra secret_generate db_root_password v1
   ```

7. `abra deploy`
8. Open the configured domain in your browser to finish set-up
9. `abra run wordpress chown www-data:www-data /var/www/html/wp-content` to fix
   file permissions (see #3)

## Network (Multi-site)

_(Only tested using subdomains)_

1. Set up as above
2. Uncomment the first `# Multisite` section in `.envrc`
3. `direnv allow` (or re-run `source .envrc`)
4. `abra deploy`
5. Log into the Wordpress admin dashboard, go to Tools » Network Setup
6. Don't worry about the suggested file changes
7. Comment out the first `# Multisite` section in `.envrc` and uncomment the
   `# Multisite phase 2` section
8. `direnv allow` (or re-run `source .envrc`)
9. `abra deploy`
10. FIXME setting up SSL / routing

## Installing a custom theme

`abra cp ~/path/to/local/theme wordpress:/var/www/html/wp-content/themes/`

## Backups

1. Edit `.envrc` and uncomment the `export COMPOSE_FILE="compose.yml:compose.backup.yml"` line
2. `direnv allow`
3. `abra deploy`

## Email

1. Deploy `postfix-relay`
2. Edit `.envrc` and uncomment the email lines; change `MAIL_FROM` to make sure
   the domain is the same as `postfix-relay`'s `$DOMAIN` or in its
   `$EXTRA_SENDER_DOMAINS`
3. `direnv allow` (or `source .envrc`)
7. `abra deploy`

[abra]: https://git.autonomic.zone/autonomic-cooperative/abra
[compose-traefik]: https://git.autonomic.zone/compose-stacks/traefik
