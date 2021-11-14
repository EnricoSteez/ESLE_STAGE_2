#!/bin/bash
kafka/bin/kafka-topics.sh --create --topic bench --partitions 3 --replication-factor 3 --bootstrap-server localhost:9092 --if-not-exists
kafka/bin/kafka-topics.sh --delete --topic bench --bootstrap-server localhost:9092 --if-exists
kafka/bin/kafka-topics.sh --describe --topic bench --bootstrap-server localhost:9092 --if-exists
kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

# In case the topic is marked for deletion but does not get deleted
# Execute zkCli.sh on the zookeeper node and execute:
rmr /brokers/topics/bench

sudo docker exec -it d076ae9c4aa4 kafka/bin/kafka-topics.sh --create --topic bench --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092 --if-not-exists
sudo docker exec -it d076ae9c4aa4 kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092
sudo docker exec -it d076ae9c4aa4 kafka/bin/kafka-topics.sh --delete --topic bench --bootstrap-server localhost:9092 --if-exists
