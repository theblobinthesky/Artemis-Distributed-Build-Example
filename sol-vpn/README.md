### Install Wireguard on every VM:
<code>
sudo apt update
sudo apt install -y wireguard
</code>

### Generate PUB/PRIVATE keys.
<code>
wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey
</code>

### Wireguard configs
#### Wireguard config `/etc/wireguard/wg0.conf` for VM-1
<code>
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
</code>

#### Wireguard config `/etc/wireguard/wg0.conf` for VM-1
<code>
[Interface]
Address = 10.99.0.2/24
PrivateKey = <contents of /etc/wireguard/privatekey on VM-2>
ListenPort = 51820

PostUp   = sysctl -w net.ipv4.ip_forward=1; \
           iptables -A FORWARD -i wg0 -j ACCEPT; \
           iptables -A FORWARD -o wg0 -j ACCEPT
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; \
           iptables -D FORWARD -o wg0 -j ACCEPT

[Peer]
PublicKey         = <contents of /etc/wireguard/publickey on VM-1>
AllowedIPs        = 10.99.0.1/32, 172.30.0.0/24
Endpoint          = <VM-1’s LAN IP>:51820
PersistentKeepalive = 25
</code>

### Wireguard autostart on both VMs
<code>
sudo systemctl enable wg-quick@wg0
sudo wg-quick up wg0
</code>

### Wireguard ping test
<code>
wg show
ping -c3 10.99.0.2 # in VM-1: from VM-1 → to VM-2
</code>

### 
<code>
docker network rm hazelcast-net 2>/dev/null || true
docker network create \
  --driver bridge \
  --subnet 172.30.0.0/24 \
  --gateway 172.30.0.1 \
  --opt com.docker.network.bridge.enable_ip_masquerade=false \
  hazelcast-net
</code>