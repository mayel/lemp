# wordpress

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

[abra]: https://git.autonomic.zone/autonomic-cooperative/abra
[compose-traefik]: https://git.autonomic.zone/compose-stacks/traefik
