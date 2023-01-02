sudo apt install ssh -y
sudo apt install curl -y


#EXAMPLE
#./iplon_ip _conf.sh (last4digofip) iplon321 projname ethnetname

./iplon_ip_conf.sh 4221 iplon321 iyyermalai enp2s0







./setup-user_root.sh
./setup-user_iplon.sh





cp /home/ubuntu/ansible/tunnelvpn.service /etc/systemd/system/






#!/bin/bash

cd /opt
mkdir iplon
cd /opt/iplon
mkdir scripts
cp /home/ubuntu/ansible/iplon_vpn.sh /opt/iplon/scripts/
