sudo apt install ssh -y
sudo apt install curl -y


#EXAMPLE
#./iplon_ip _conf.sh (last4digofip) iplon321 projname ethnetname

./iplon_ip_conf.sh 4221 iplon321 iyyermalai enp2s0







./setup-user_root.sh
./setup-user_iplon.sh





cp /home/iplon/ansible/tunnelvpn.service /etc/systemd/system/






#!/bin/bash

cd /opt
mkdir iplon
cd /opt/iplon
mkdir scripts
cp /home/iplon/ansible/iplon_vpn.sh /opt/iplon/scripts/


mkdir -p /etc/docker/certs.d/ivpn.iplon.co.in:8443

cp /home/iplon/ansible/ca.crt /etc/docker/certs.d/ivpn.iplon.co.in:8443
