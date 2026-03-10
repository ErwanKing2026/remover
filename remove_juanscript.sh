#!/bin/bash
echo "Removing JuanScript components..."

systemctl stop JuanDNS JuanTCP JuanTLS JuanWS JuanDNSTT udp juanssh badvpn-udpgw squid ddos juanconn 2>/dev/null
systemctl disable JuanDNS JuanTCP JuanTLS JuanWS JuanDNSTT udp juanssh badvpn-udpgw squid ddos juanconn 2>/dev/null

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

echo "Removing directories..."
rm -rf /etc/JuanScript
rm -rf /etc/JuanSSH
rm -rf /etc/udp
rm -rf /etc/profile.d/juan.sh

echo "Removing OpenVPN configs..."
rm -rf /etc/openvpn/server
rm -rf /etc/openvpn/certificates
rm -rf /etc/openvpn/configs

echo "Removing stunnel..."
systemctl stop stunnel4
apt purge -y stunnel4

echo "Removing packages..."
apt purge -y openvpn nginx squid hysteria mysql-server badvpn
apt autoremove -y

echo "Resetting iptables..."
iptables -F
iptables -t nat -F
netfilter-persistent save

echo "Removing menu command..."
rm -f /usr/bin/menu

echo "Cleaning logs..."
rm -rf /var/log/xray

echo "JuanScript removed."
