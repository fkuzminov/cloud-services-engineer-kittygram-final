#!/bin/sh

docker_file="docker-compose.yaml"
backend_container_name="backend"

sudo docker compose -f ${docker_file} down
sudo docker compose -f ${docker_file} pull
sudo docker compose -f ${docker_file} up -d
sudo docker exec -it ${backend_container_name} bash python3 manage.py migrate
sudo docker exec -it ${backend_container_name} bash python3 manage.py collectstatic --noinput
