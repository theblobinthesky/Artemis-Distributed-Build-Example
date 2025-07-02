IP=$(ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
echo "IP: $IP"

docker swarm init --advertise-addr $IP
docker network create \
  --driver overlay \
  --attachable \
  --subnet 172.30.0.0/24 \
  --gateway 172.30.0.1 \
  my_overlay