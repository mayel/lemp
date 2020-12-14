sub_wp() {
  load_instance
  load_instance_env
	CONTAINER=$(docker container ls -f "Name=${STACK_NAME}_app" --format '{{ .ID }}')
  if [ -z "$CONTAINER" ]; then
    error "Can't find a container for ${STACK_NAME}_app"
    exit
  fi
	# shellcheck disable=SC2154,SC2086
	docker run -it --volumes-from "$CONTAINER" --network "container:$CONTAINER" wordpress:cli wp $abra__arg_
}
