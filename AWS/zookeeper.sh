sudo docker swarm init

sudo docker network create --driver overlay kafka-net

sudo docker node update --label-add zoo=1 ip-172-31-8-246
sudo docker node update --label-add kafka=1 ip-172-31-8-246

sudo docker service create \
  --name zookeeper \
  --mount type=volume,source=zoo-data,destination=/tmp/zookeeper \
  --publish 2181:2181 \
  --constraint node.labels.zoo==1 \
  --network kafka-net \
  --mode global \
  enricosteez/eslekafka:latest \
/kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties
