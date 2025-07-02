DOCKER_GROUP_ID=$(getent group docker | cut -d: -f3)
echo -e "Docker Group Id: $DOCKER_GROUP_ID"
echo "DOCKER_GROUP_ID=$DOCKER_GROUP_ID" > .env

docker-compose down -v
docker-compose rm
docker-compose up artemis-build-agent-1
