export NGINX_DEFAULT_CONF_VERSION=v6
export PHP_UPLOADS_CONF_VERSION=v3
export ENTRYPOINT_CONF_VERSION=v2
export ENTRYPOINT_MAILRELAY_CONF_VERSION=v1
export MSMTP_CONF_VERSION=v3

abra_backup_app() {
  _abra_backup_dir "app:/var/www/html/"
}

abra_backup_db() {
  _abra_backup_mysql "db" "site"
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

  zcat "$@" | sub_app_run mysql -u root -p"$DB_ROOT_PASSWORD" site

  success "Restored 'db'"
}
