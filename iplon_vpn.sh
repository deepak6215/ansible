#!/bin/bash

#set -x
current_time=$(date +"%D - %r")

DATADIR="/opt/iplon/scripts/"
CONFDIR="/tmp/"
CLOUD_IP="http://ivpn.iplon.co.in"

cd $DATADIR

readFieldFromDB() {
   local DBERROR_=1
   local T_=0
   local RSLT_=""
       local fmt_="-list"
       if [ "x$2" = "xcsv" ]; then
         fmt_="-csv"
       fi
   while [ $DBERROR_ -eq 1 -a $T_ -le 15 ]; do
     RSLT_=$(sqlite3 $fmt_ /var/spool/db "$1" 2>&1 | dos2unix)
     DBERROR_=`echo $RSLT_ | grep -ci "database is locked"`
     T_=$(($T_+1))
     if [ $DBERROR_ -eq 1 ]; then
       bash -c "sleep 1 && echo vpn.shReadFieldFromDb $PROFILE > /dev/null"
     fi
   done
   if [ $DBERROR_ -ne 1 ]; then
     DBERROR_=`echo $RSLT_ | grep -ci "error"`
   fi
   if [ $DBERROR_ -ne 0 ]; then
     echo $RSLT_ >&2
     return 1
   else
     echo $RSLT_
     return 0
   fi
}

#iGate_ID=$(readFieldFromDB "SELECT value from unit where field=\"id\"")
iGate_ID="4286"

conf_file=$iGate_ID"_1_1.txt"
echo $current_time > $CONFDIR$conf_file

if ping -c 5 8.8.8.8 &> /dev/null
then
    sleep 10;
    if ping -c 5 10.8.0.1 &> /dev/null
    then
        echo "vpn is working - "$current_time >> /var/log/iplon/iplon_vpn.log
        exit 0;
    else
        if [[ ($(/usr/bin/curl -F file=@$CONFDIR$conf_file $CLOUD_IP/get_vpn.php --max-time 120 | grep -c "Originalname") -eq 1) ]];
        then
            sleep 120;
	        $(/usr/bin/curl $CLOUD_IP/iGate_ovpn_files/${iGate_ID}.ovpn --output /etc/openvpn/client/client.conf)
	        #$(cp ${iGate_ID}.ovpn /etc/openvpn/client/bala.conf)
            sleep 5;
            service tunnelvpn restart
            systemctl enable tunnelvpn
	    fi
    fi
else
    echo "network is not available not able to create VPN network run script again" >> /var/log/iplon/iplon_vpn.log
    service tunnelvpn stop
    sleep 3;
    service tunnelvpn start
    sleep 300;
    /opt/iplon/scripts/iplon_vpn.sh
fi


