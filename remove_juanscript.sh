#!/bin/bash

rm -rf *
SCRIPT_PATH=$(realpath "$0")
rm -rf "$SCRIPT_PATH"

echo "======================================"
echo "   JuanScript Deep Remover v2"
echo "======================================"

if [ "$(id -u)" != "0" ]; then
    echo "Run as root!"
    exit 1
fi

echo "[1/10] Stopping services..."

services=(
JuanDNS
JuanTCP
JuanTLS
JuanWS
JuanDNSTT
udp
juanssh
badvpn-udpgw
ddos
juanconn
squid
stunnel4
openvpn-server@tcp
openvpn-server@udp
)

for s in "${services[@]}"; do
systemctl stop $s 2>/dev/null
systemctl disable $s 2>/dev/null
done

echo "[2/10] Removing systemd services..."

rm -f /lib/systemd/system/JuanDNS.service
rm -f /lib/systemd/system/JuanTCP.service
rm -f /lib/systemd/system/JuanTLS.service
rm -f /lib/systemd/system/JuanWS.service
rm -f /lib/systemd/system/JuanDNSTT.service
rm -f /etc/systemd/system/udp.service
rm -f /lib/systemd/system/badvpn-udpgw.service
rm -f /lib/systemd/system/juanconn.service
rm -f /etc/systemd/system/juanssh.service

systemctl daemon-reload

echo "[3/10] Removing JuanScript directories..."

rm -rf /etc/JuanScript
rm -rf /etc/JuanSSH
rm -rf /etc/udp

echo "[4/10] Removing VPN configs..."

rm -rf /etc/openvpn
rm -rf /etc/stunnel
rm -rf /var/log/xray

echo "[5/10] Removing custom binaries..."

rm -f /usr/bin/menu
rm -f /usr/local/bin/badvpn-udpgw
rm -rf /usr/local/src/badvpn

echo "[6/10] Removing Go installation..."

rm -rf /usr/local/go

echo "[7/10] Removing cron jobs..."

rm -f /etc/cron.d/reboot_at_8am
rm -f /etc/cron.d/reboot_at_6pm

echo "[8/10] Resetting firewall..."

iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

netfilter-persistent save 2>/dev/null

echo "[9/10] Restoring SSH port..."

if grep -q "Port 7392" /etc/ssh/sshd_config; then
sed -i 's/Port 7392/Port 22/' /etc/ssh/sshd_config
systemctl restart ssh
fi

echo "[10/10] Cleaning packages..."

apt purge -y openvpn nginx squid stunnel4 2>/dev/null
apt autoremove -y

echo ""
echo "--------------------------------------"
echo " JuanScript completely removed"
echo "--------------------------------------"

rm -rf /root/*
apt autoremove -y
reboot
