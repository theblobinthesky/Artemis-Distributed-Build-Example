#!/usr/bin/env bash

# ANSI color variables
COLOR_INFO='\033[1;34m'   # bright blue
RESET='\033[0m'


# Export docker group id, so the build agent can use the socket.
DOCKER_GROUP_ID=$(getent group docker | cut -d: -f3)
echo -e "${COLOR_INFO}Docker Group Id: $DOCKER_GROUP_ID"
echo "DOCKER_GROUP_ID=$DOCKER_GROUP_ID" > .env


# Startup the dependencies using docker-compose:
echo -e "${COLOR_INFO}⏳ Starting dependencies and all instances using docker-compose...${RESET}"

# Postgres, JHipster and ActiveMQ:
sudo docker-compose down -v
sudo docker-compose rm
sudo rm -rf postgresql-data
# sudo docker-compose up # --detach
