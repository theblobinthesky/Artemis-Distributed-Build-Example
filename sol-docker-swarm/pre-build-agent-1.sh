docker swarm leave --force
docker swarm join --token $1 $2:2377
