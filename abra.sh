export PHP_UPLOADS_CONF_VERSION=v3
export ENTRYPOINT_CONF_VERSION=v2
export ENTRYPOINT_MAILRELAY_CONF_VERSION=v1
export MSMTP_CONF_VERSION=v1

sub_wp() {
  load_instance
  load_instance_env
	CONTAINER=$(docker container ls -f "Name=${STACK_NAME}_app" --format '{{ .ID }}')
  if [ -z "$CONTAINER" ]; then
    error "Can't find a container for ${STACK_NAME}_app"
    exit
  fi
	# shellcheck disable=SC2154,SC2086
	docker run -it --volumes-from "$CONTAINER" --network "container:$CONTAINER" wordpress:cli wp ${abra__args_[*]}
}

abra_backup_app() {
  # shellcheck disable=SC2034
  {
	abra__src_="app:/var/www/html/wp-content"
	abra__dst_="-"
  }

  # shellcheck disable=SC2154
  FILENAME="$ABRA_DIR/backups/${abra__app_}_wp-content_$(date +%F).tar.gz"

  sub_app_cp | gzip > "$FILENAME"

  success "Backed up 'app' to $FILENAME"
}

abra_backup_db() {
  # shellcheck disable=SC2034
  abra__service_="db"
  # 3wc: necessary because $abra__service_ won't be set if we're coming from 
  # `abra_backup`, i.e. `abra app ... backup --all`

  DB_ROOT_PASSWORD=$(sub_app_run cat /run/secrets/db_root_password)

  # shellcheck disable=SC2154
  FILENAME="$ABRA_DIR/backups/${abra__app_}_$(date +%F).sql.gz"

  sub_app_run mysqldump -u root -p"$DB_ROOT_PASSWORD" wordpress | gzip > "$FILENAME"

  success "Backed up 'db' to $FILENAME"
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
