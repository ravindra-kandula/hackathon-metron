cd /home/ec2-user/
mkdir metron
cd metron/
git clone --recursive https://github.com/apache/metron

cd /opt
wget http://apache.mirrors.lucidnetworks.net/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz
tar -xzf apache-maven-3.5.2-bin.tar.gz
export PATH=$PATH:/opt/apache-maven-3.5.2/bin
cd /tmp
mkdir metron
cd metron/
git clone --recursive https://github.com/ravindra-kandula/hackathon-metron.git
cd hackathon-metron/pcap-parser
mvn install
cd target/
/var/lib/ambari-server/resources/scripts/configs.py -a set  -l localhost -n hdp -k worker.childopts -v "-Xmx4072m _JAAS_PLACEHOLDER -javaagent:/usr/hdp/current/storm-client/contrib/storm-jmxetric/lib/jmxetric-1.0.4.jar=host=localhost,port=8650,wireformat31x=true,mode=multicast,config=/usr/hdp/current/storm-client/contrib/storm-jmxetric/conf/jmxetric-conf.xml,process=Worker_%ID%_JVM" -u admin -p admin -c storm-site
curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"HostRoles": {"state": "STARTED"}}' http://127.0.0.1/api/v1/clusters/hdp/hosts/demo.hortonworks.com/host_components/METRON_PARSERS
sleep 30

cp pcap-parser-0.0.1-SNAPSHOT-uber.jar /usr/hcp/current/metron/lib
cd /usr/hcp/current/metron/config/zookeeper/indexing
cp yaf.json pcap-index.json
sed -i "s/yaf/pcap-index/g" pcap-index.json
cd /usr/hcp/current/metron/config/zookeeper/enrichments
cp yaf.json pcap-index.json
cd /usr/hcp/current/metron/config/zookeeper/parsers
echo "{" > pcap-index.json
echo ' "parserClassName":"org.apache.metron.parsers.json.PCAPParser",' >> pcap-index.json
echo '  "sensorTopic":"pcap" ' >> pcap-index.json
echo "}" >> pcap-index.json

export METRON_HOME=/usr/hcp/current/metron
$METRON_HOME/bin/zk_load_configs.sh -m PUSH -z 127.0.0.1 -i $METRON_HOME/config/zookeeper

curl -u admin:admin -i -H 'X-Requested-By: ambari' -X PUT -d '{"HostRoles": {"state": "INSTALLED"}}' http://127.0.0.1/api/v1/clusters/hdp/hosts/demo.hortonworks.com/host_components/METRON_PARSERS


# Start by making sure your system is up-to-date:
yum update
# Compilers and related tools:
yum groupinstall -y "development tools"
# Libraries needed during compilation to enable all features of Python:
yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel expat-devel
# If you are on a clean "minimal" install of CentOS you also need the wget tool:
yum install -y wget
# Python 2.7.14:
wget http://python.org/ftp/python/2.7.14/Python-2.7.14.tar.xz
tar xf Python-2.7.14.tar.xz
cd Python-2.7.14
./configure --prefix=/usr/local --enable-unicode=ucs4 --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make && make altinstall
wget https://bootstrap.pypa.io/get-pip.py
python2.7 get-pip.py

cd /tmp
export PREFIX=/usr
wget https://github.com/edenhill/librdkafka/archive/v0.9.4.tar.gz  -O - | tar -xz
cd librdkafka-0.9.4/
./configure --prefix=$PREFIX
make
make install
echo "$PREFIX/lib" >> /etc/ld.so.conf.d/pycapa.conf
ldconfig -v 

#install pycapa
cd /home/ec2-user/metron/metron/metron-sensors/pycapa/
/usr/local/bin/pip2.7 -r requirements.txt
sudo /usr/local/bin/pip2.7 install -r requirements.txt
sudo /usr/local/bin/python2.7 setup.py install

yum install -y tcpreplay


#Start pcap topology
cp /tmp/metro/hackathon-metron/scripts/pcap.properties /usr/hcp/current/metron/config
cp /tmp/metro/hackathon-metron/scripts/start_parser_topology.sh /usr/hcp/current/metron/bin/

/usr/hcp/current/metron/bin/start_pcap_topology.sh
#delpoy zeppelin notebook


curl -XPOST http://localhost:9200/_template/pcap-index_index -d '
{
"template": "pcap-index_index*",
"mappings": {
"pcap-index_doc": {
"properties": {
"enrichments:geo:ip_dst_addr:locID": {
"type": "integer"
},
"ip_fragment_offset": {
"type": "long"
},
"enrichments:geo:ip_dst_addr:location_point": {
"type": "geo_point"
},
"enrichments:geo:ip_dst_addr:dmaCode": {
"type": "string",
 "index": "not_analyzed"
},
"ip_tos": {
"type": "long"
},
"threatinteljoinbolt:joiner:ts": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_src_addr:longitude": {
"type": "string",
 "index": "not_analyzed"
},
"enrichmentsplitterbolt:splitter:begin:ts": {
"type": "string",
 "index": "not_analyzed"
},
"ip_id": {
"type": "long"
},
"ip_src": {
"type": "long"
},
"enrichmentjoinbolt:joiner:ts": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_src_addr:dmaCode": {
"type": "string",
 "index": "not_analyzed"
},
"adapter:geoadapter:begin:ts": {
"type": "string",
 "index": "not_analyzed"
},
"ip_header_length": {
"type": "long"
},
"enrichments:geo:ip_dst_addr:latitude": {
"type": "string",
 "index": "not_analyzed"
},
"ip_ttl": {
"type": "long"
},
"source:type": {
"type": "string",
 "index": "not_analyzed"
},
"adapter:threatinteladapter:end:ts": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_src_addr:locID": {
"type": "geo_point"
},
"ip_dst_addr": {
"type": "string",
 "index": "not_analyzed"
},
"original_string": {
"type": "string",
 "index": "not_analyzed"
},
"ip_version": {
"type": "long"
},
"adapter:hostfromjsonlistadapter:end:ts": {
"type": "string",
 "index": "not_analyzed"
},
"ip_total_length": {
"type": "long"
},
"adapter:geoadapter:end:ts": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_src_addr:latitude": {
"type": "string",
 "index": "not_analyzed"
},
"ip_src_addr": {
"type": "string",
 "index": "not_analyzed"
},
"threatintelsplitterbolt:splitter:end:ts": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_dst_addr:longitude": {
"type": "string",
 "index": "not_analyzed"
},
"timestamp": {
"type": "date",
 "format": "epoch_millis"
},
"enrichments:geo:ip_src_addr:location_point": {
"type": "geo_point"
},
"enrichmentsplitterbolt:splitter:end:ts": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_dst_addr:city": {
"type": "string"
},
"enrichments:geo:ip_dst_addr:postalCode": {
"type": "string",
 "index": "not_analyzed"
},
"is_alert": {
"type": "string",
 "index": "not_analyzed"
},
"adapter:hostfromjsonlistadapter:begin:ts": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_src_addr:country": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_src_addr:postalCode": {
"type": "string",
 "index": "not_analyzed"
},
"ip_dst": {
"type": "long"
},
"ip_flags": {
"type": "long"
},
"ip_protocol": {
"type": "long"
},
"ip_header_checksum": {
"type": "long"
},
"adapter:threatinteladapter:begin:ts": {
"type": "string",
 "index": "not_analyzed"
},
"guid": {
"type": "string",
 "index": "not_analyzed"
},
"threatintelsplitterbolt:splitter:begin:ts": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_dst_addr:country": {
"type": "string",
 "index": "not_analyzed"
},
"enrichments:geo:ip_src_addr:city": {
"type": "string",
 "index": "not_analyzed"
}
}
}
}
}'


