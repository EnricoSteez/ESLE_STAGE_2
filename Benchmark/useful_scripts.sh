#!/bin/bash
kafka-topics.sh --create --topic bench --partitions 3 --replication-factor 3 --zookeeper zookeeper:2181 --if-not-exists
kafka-topics.sh --delete --topic bench --zookeeper zookeeper:2181 --if-exists
kafka-topics.sh --describe --topic bench --zookeeper zookeeper:2181 --if-exists
kafka-topics.sh --list --zookeeper zookeeper:2181

# In case the topic is marked for deletion but does not get deleted
# Execute zkCli.sh on the zookeeper node and execute:
rmr /brokers/topics/bench
