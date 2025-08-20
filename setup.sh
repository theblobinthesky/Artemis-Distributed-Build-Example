#!/usr/bin/env bash

# ANSI color variables
COLOR_INFO='\033[1;34m'   # bright blue
RESET='\033[0m'


# Export docker group id, so the build agent can use the socket.
DOCKER_GROUP_ID=$(getent group docker | cut -d: -f3)
echo -e "${COLOR_INFO}Docker Group Id: $DOCKER_GROUP_ID"
echo "DOCKER_GROUP_ID=$DOCKER_GROUP_ID" > .env


# Create network.
docker network rm hz-net
docker network create \
  --driver=bridge \
  --subnet=172.30.0.0/24 \
  --gateway=172.30.0.1 \
  -o com.docker.network.bridge.name=hz-net \
  -o com.docker.network.bridge.enable_icc=true \
  -o com.docker.network.bridge.enable_ip_masquerade=true \
  hz-net
