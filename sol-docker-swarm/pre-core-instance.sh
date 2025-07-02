IP=$(ip -4 addr show enp0s3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
TOKEN=$(docker swarm init --advertise-addr $IP)

echo "IP: $IP"
echo "TOKEN: $TOKEN"
