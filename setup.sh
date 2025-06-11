#!/usr/bin/env bash

# ANSI color variables
COLOR_INFO='\033[1;34m'   # bright blue
RESET='\033[0m'

# RELEASE_VERSION=8.1.3

# Download an Artemis release:
# if ! [ -f artemis.war ]; then
#     echo -e "${COLOR_INFO}⏳ Downloading Artemis release $RELEASE_VERSION...${RESET}"
#     curl -L https://github.com/ls1intum/Artemis/releases/download/$RELEASE_VERSION/Artemis.war \
#          --output artemis.war --no-clobber
# fi

# Startup the dependencies using docker-compose:
echo ""
echo -e "${COLOR_INFO}⏳ Starting dependencies and all instances using docker-compose...${RESET}"

# Postgres, JHipster and ActiveMQ:
sudo docker-compose down -v
sudo docker-compose rm
sudo rm -rf postgresql-data
sudo docker-compose up # --detach

# # Start the main Artemis instance.
# echo ""
# echo -e "${COLOR_INFO}⏳ Starting artemis main instance...${RESET}"
# java -jar artemis.war \
#     --server.port=8080 \
#     --eureka.instance.instanceId=Artemis:1 \
#     --spring.profiles.active=prod,core,localvc,localci,scheduling,local \
#     --spring.config.additional-location=file:files/main-instance/application-local.yml
