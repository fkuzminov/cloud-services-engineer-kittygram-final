#!/bin/sh

docker_file="docker-compose.production.yml"
backend_container_name="backend"

# For the first run when we don't have any active containers
set +e
docker compose -f ${docker_file} down
set -e
docker compose -f ${docker_file} pull
docker compose -f ${docker_file} up -d
docker exec ${backend_container_name} python manage.py migrate
docker exec ${backend_container_name} python manage.py collectstatic --noinput
