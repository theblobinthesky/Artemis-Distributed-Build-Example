IP=ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'
docker swarm join --token $1 