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
}

abra_backup_db() {
  # shellcheck disable=SC2034
  abra__service_="db"

  DB_ROOT_PASSWORD=$(sub_app_run cat /run/secrets/db_root_password)

  # shellcheck disable=SC2154
  FILENAME="$ABRA_DIR/backups/${abra__app_}_$(date +%F).sql.gz"

  sub_app_run mysqldump -u root -p"$DB_ROOT_PASSWORD" wordpress | gzip > "$FILENAME"
}

abra_backup() {
  abra_backup_app && abra_backup_db
}
