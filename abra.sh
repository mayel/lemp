export PHP_UPLOADS_CONF_VERSION=v3
export ENTRYPOINT_CONF_VERSION=v2
export ENTRYPOINT_MAILRELAY_CONF_VERSION=v1
export MSMTP_CONF_VERSION=v2

sub_wp() {
  CONTAINER=$(docker container ls -f "Name=${STACK_NAME}_app" --format '{{ .ID }}')
  if [ -z "$CONTAINER" ]; then
    error "Can't find a container for ${STACK_NAME}_app"
    exit
  fi
  debug "Using Container ID ${CONTAINER}"

  # FIXME 3wc: we're fighting the Wordpress image, which recommends a named
  # volume for /var/www/html -- this used to work fine using --volumes-from
  # because the actual MySQL password was inserted into the generated
  # wp-config.php -- but as of Wordpress 5.7.0, wp-config loads data straight
  # from the environment, which requires Docker secrets to work, which only work
  # in swarm services (not one-off `docker run` commands). Defining a `cli`
  # service in compose.yml almost works, but there's no volumes_from: in Compose
  # V3, and without it then the `cli` service can't access Wordpress core.
  # See https://git.autonomic.zone/coop-cloud/wordpress/issues/21
  warning "Slowly looking up MySQL password..."
  silence
  abra__service_="app"
  DB_PASSWORD="$(sub_app_run cat "/run/secrets/db_password")"
  unsilence

  # shellcheck disable=SC2154,SC2086
  docker run -it \
	--volumes-from "$CONTAINER" \
	--network "container:$CONTAINER" \
	-u xfs:xfs \
    -e WORDPRESS_DB_HOST=db \
    -e WORDPRESS_DB_USER=wordpress \
    -e WORDPRESS_DB_PASSWORD="${DB_PASSWORD}" \
    -e WORDPRESS_DB_NAME=wordpress \
    -e WORDPRESS_CONFIG_EXTRA="${WORDPRESS_CONFIG_EXTRA}" \
	wordpress:cli wp ${abra__args_[*]}
}

abra_backup_app() {
  _abra_backup_dir "app:/var/www/html/wp-content"
}

abra_backup_db() {
  _abra_backup_mysql "db" "wordpress"
}

abra_backup() {
  abra_backup_app && abra_backup_db
}

abra_restore_app() {
  # shellcheck disable=SC2034
  {
	abra__src_="-"
	abra__dst_="app:/var/www/html/"
  }

  zcat "$@" | sub_app_cp

  success "Restored 'app'"
}

abra_restore_db() {
  # 3wc: unlike abra_backup_db, we can assume abra__service_ will be 'db' if we
  # got this far..

  # shellcheck disable=SC2034
  abra___no_tty="true"

  DB_ROOT_PASSWORD=$(sub_app_run cat /run/secrets/db_root_password)

  zcat "$@" | sub_app_run mysql -u root -p"$DB_ROOT_PASSWORD" wordpress

  success "Restored 'db'"
}
