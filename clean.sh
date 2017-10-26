hdfs dfs -rm /apps/metron/pcap/*
hdfs dfs -rm /apps/metron/indexing/indexed/pcap-index/*.json
curl -XDELETE "http://localhost:9200/pcap-index*"
