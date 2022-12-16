#!/bin/bash

set -x

if [ $# -lt 3 ]
then
 echo "Usage script Server_ID MySQL_DB_PASSWORD PLANT_NAME"
 exit 1
fi

SCRIPT_DIR=$(pwd)
SERVER_ID=$1
MYSQL_PASS=$2
PMA_PASS=$2
PLANT_NAME=$3
ETHERNET_DEV=$4
IPLON_PACKAGE_PATH="/opt/iplon"
DB="iSolar_db"

NTP_IP="192.168."$(echo $SERVER_ID | cut -c1-2).81
SERVER_IP="192.168."$(echo $SERVER_ID | cut -c1-2).$(echo $SERVER_ID | cut -c3-4)
FIREWALL_IP="192.168."$(echo $SERVER_ID | cut -c1-2).100
NetPlan_File=$(ls /etc/netplan/*yaml)

$(> $NetPlan_File)

echo "# Let NetworkManager manage all devices on this system
network:
  version: 2
  renderer: networkd
  ethernets:
    $ETHERNET_DEV:
      addresses:
      - $SERVER_IP/24
      gateway4: $FIREWALL_IP
      nameservers:
        addresses:
        - 8.8.8.8
        - 8.8.4.4" >>$NetPlan_File

netplan apply
