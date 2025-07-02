### Install Wireguard on every VM:
```
sudo apt update
sudo apt install -y wireguard
```

### Generate PUB/PRIVATE keys.
```
wg genkey | sudo tee /etc/wireguard/privatekey | wg pubkey | sudo tee /etc/wireguard/publickey
# wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey
```

### Wireguard configs
#### Wireguard config `/etc/wireguard/wg0.conf` for VM-1
```
[Interface]
Address = 10.99.0.1/24
PrivateKey = <contents of /etc/wireguard/privatekey on VM-1>
ListenPort = 51820

PostUp   = sysctl -w net.ipv4.ip_forward=1; \
           iptables -A FORWARD -i wg0 -j ACCEPT; \
           iptables -A FORWARD -o wg0 -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; \
           iptables -D FORWARD -o wg0 -j ACCEPT

[Peer]
PublicKey         = <contents of /etc/wireguard/publickey on VM-2>
AllowedIPs        = 10.99.0.2/32, 172.30.0.0/24
Endpoint          = <VM-2’s LAN IP>:51820
PersistentKeepalive = 25
```

#### Wireguard config `/etc/wireguard/wg0.conf` for VM-1
```
[Interface]
Address = 10.99.0.2/24
PrivateKey = <contents of /etc/wireguard/privatekey on VM-2>
ListenPort = 51820

PostUp   = sysctl -w net.ipv4.ip_forward=1; iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT

[Peer]
PublicKey         = <contents of /etc/wireguard/publickey on VM-1>
AllowedIPs        = 10.99.0.1/32, 172.30.0.0/24
Endpoint          = <VM-1’s LAN IP>:51820
PersistentKeepalive = 25
```

### Wireguard autostart on both VMs
```
sudo systemctl enable wg-quick@wg0
reboot
# sudo wg-quick up wg0 (not recommended; just reboot)
```

### Wireguard ping test
```
wg show
ping -c3 10.99.0.2 # in VM-1: from VM-1 → to VM-2
```

### Run this once on the core instance
```
docker network rm hazelcast-net 2>/dev/null || true
docker network create \
  --driver bridge \
  --subnet 172.30.0.0/24 \
  --gateway 172.30.0.1 \
  --opt com.docker.network.bridge.enable_ip_masquerade=false \
  hazelcast-net
```