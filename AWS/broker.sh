sudo docker service create \
--name kafka1 \
--mount type=volume,source=k1-logs,destination=/tmp/kafka-logs \
--publish 9093:9093 \
--network kafka-net \
--mode global \
--constraint node.labels.kafka==1 \
enricosteez/eslekafka:latest \
/kafka/bin/kafka-server-start.sh /kafka/config/server.properties \
 --override listeners=INT://:9092,EXT://0.0.0.0:9093 \
 --override listener.security.protocol.map=INT:PLAINTEXT,EXT:PLAINTEXT \
 --override inter.broker.listener.name=INT \
 --override advertised.listeners=INT://:9092,EXT://node3:9093 \
 --override zookeeper.connect=zookeeper:2181 \
 --override broker.id=1

sudo docker service create \
--name kafka2 \
--mount type=volume,source=k2-logs,destination=/tmp/kafka-logs \
--publish 9094:9094 \
--network kafka-net \
--mode global \
--constraint node.labels.kafka==2 \
enricosteez/eslekafka:latest \
/kafka/bin/kafka-server-start.sh /kafka/config/server.properties \
--override listeners=INT://:9092,EXT://0.0.0.0:9094 \
--override listener.security.protocol.map=INT:PLAINTEXT,EXT:PLAINTEXT \
--override inter.broker.listener.name=INT \
--override advertised.listeners=INT://:9092,EXT://node3:9094 \
--override zookeeper.connect=zookeeper:2181 \
--override broker.id=2

sudo docker service create \
--name kafka3 \
--mount type=volume,source=k3-logs,destination=/tmp/kafka-logs \
--publish 9095:9095 \
--network kafka-net \
--mode global \
--constraint node.labels.kafka==3 \
enricosteez/eslekafka:latest \
/kafka/bin/kafka-server-start.sh /kafka/config/server.properties \
--override listeners=INT://:9092,EXT://0.0.0.0:9095 \
--override listener.security.protocol.map=INT:PLAINTEXT,EXT:PLAINTEXT \
--override inter.broker.listener.name=INT \
--override advertised.listeners=INT://:9092,EXT://node3:9095 \
--override zookeeper.connect=zookeeper:2181 \
--override broker.id=3

kafka/bin/kafka-topics.sh \
--bootstrap-server IP-172-31-8-82:2181 \
--create \
--replication-factor 1 \
--partitions 1 \
--topic bench

kafka/bin/kafka-topics.sh \
--bootstrap-server node0 
--create \
--replication-factor 1 \
--partitions 1 \
--topic bench
