#!/bin/bash
KAFKA_BROKER=demo.hortonworks.com:6667
VIRTUAL_INTERFACE=dummy0
PCAP_TOPIC=pcap-index
#Take the name of the replay file from the command line if provided
if [ $# -gt 0 ];then
    REPLAY_FILE=$1
else
    REPLAY_FILE=/home/ec2-user/pcap/suspicious_ftp_traffic.pcap
fi
function startReplay {
# Make sure the dummy network interface is loaded
modprobe dummy
# Bring up the dummy interface
ip addr list dummy0
if [ $? -eq 1 ];then
    ip link add $VIRUAL_INTERFACE type dummy
else
    #Bring up the interface
    ip link set dev $VIRTUAL_INTERFACE up
fi
#Start capturing data on, but first make sure it's not running
pgrep pycapa
if [ $? -eq 1 ];then
nohup  /usr/local/bin/pycapa --producer \
    --interface $VIRTUAL_INTERFACE \
    --kafka-broker $KAFKA_BROKER \
    --kafka-topic $PCAP_TOPIC \
    --pretty-print 5 &> /dev/null &
fi
tcpreplay -i dummy0 $REPLAY_FILE
}
startReplay

