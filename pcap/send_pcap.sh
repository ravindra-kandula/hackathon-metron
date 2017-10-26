#!/bin/bash
set -x
START=$1
END=$2
EMAIL=$3
UUID=`uuidgen`
PCAP_WEBROOT=/tmp/www/pcap
PCAP_HTTP_PORT=80
PCAP_FULLPATH=$PCAP_WEBROOT/$UUID
#
mkdir -p $PCAP_FULLPATH
cd $PCAP_FULLPATH
/usr/hcp/current/metron/bin/pcap_query.sh fixed -st $START #-et $END 
if [ $? -eq 0 ];then
    HOSTNAME=`curl -s ip.alt.io`
    echo "A PCAP file was generated.  Please check your email to obtain a link for accessing the PCAP(s)."
    echo "A PCAP file was genearated and can be found at http://$HOSTNAME:$PCAP_HTTP_PORT/$UUID" | mail -s "PCAP file for $START" $EMAIL
    
fi
