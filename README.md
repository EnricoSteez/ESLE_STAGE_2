# ESLE_STAGE_2
Stage 2 of the Large Scale Engineering project (2021/2022)

## AWS PROCEDURE ##
The AWS procedure has been used for the tentative deployment and it is working provided that you can afford decent machines (t3.small or better).
This procedure assumes that you already have AWS CLI installed and configured, as well as Docker.
It also assumes that you generated a key pair to ssh into the ec2 instances and that the Security Group of the ec2 instances is configured with the necessary ports open:
 - 22 TCP
 - 2376 TCP
 - 2377 TCP
 - 7946 UDP
 - 7946 TCP
 - 4789 UDP

Configure the type of instances, as well as the key for the machines in the main.tf file
Move to the AWS folder.

First, create a new docker context to deploy the infrastructure on AWS instead of the default platform (localhost):

`docker context create ecs <nameofcontext>`

`docker context use <nameofcontext>`

deploy the machines with Terraform: `terraform apply`

ssh into Broker0

Init the swarm with Broker0 as manager: `docker swarm init`

Add the other machines to the swarm as workers: 
```
docker swarm join --token <swarm-token> IP-X-X-X-X:2377
docker swarm join --token <swarm-token> IP-X-X-X-X:2377
``` 

(where IP-X-X-X-X are the names of the machines corresponding to Broker1, Broker2)
From now on, commands starting with:
"manager >" will be performed into the Broker 0 ec2 machine

```
manager > docker node update --label-add zoo=1 IP-1-1-1-1
manager > docker node update --label-add kafka=1 IP-1-1-1-1
manager > docker node update --label-add kafka=2 IP-2-2-2-2
manager > docker node update --label-add kafka=3 IP-3-3-3-3

manager > docker network create --driver overlay kafka-net
```
Now create the zookeeper service on the manager node:

```
sudo docker service create \
  --name zookeeper \
  --mount type=volume,source=zoo-data,destination=/tmp/zookeeper \
  --publish 2181:2181 \
  --constraint node.labels.zoo==1 \
  --network kafka-net \
  --mode global \
  enricosteez/eslekafka:latest \
/kafka/bin/zookeeper-server-start.sh /kafka/config/zookeeper.properties
```

As well as the "main" broker:

```
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
```
Create the topic:
`sudo docker exec -it <containerID> kafka/bin/kafka-topics.sh --create --topic bench --partitions 1 --replication-factor 1 --bootstrap-server localhost:9092 --if-not-exists`
Where containerID is the ID of the container running the broker service in swarm mode

Move to the benchmark folder.
Ssh into the Benchmark ec2 machine and execute the benchmarks:

```
host > pyhton3 benchmarkProducer.py bench <MANAGER_IP:9093> <TIME> &
pyhton3 benchmarkConsumer.py bench <MANAGER_IP:9093> <TIME> &
```


## LOCAL PROCEDURE ##
This procedure has been used instead of the one previously described because of the reasons stated in the report.
It has many similarities with the stage 1 tutorial but I updated some images and made the whole environment better performing and more stable.

Move to the LOCAL folder

Edit the docker-compose.yml file to create only the services "zookeeper" and "kafka" (comment kafka-2, kafka-3 etc until the end of the file).

Spin up the environment: `docker-compose up -d`

Create the topic: 

`kafka/bin/kafka-topics.sh --create --topic bench4 --bootstrap-server localhost:29092 --partitions 2 --replication-factor 1`

Move to the benchmark folder and run the benchmarks:

`python3 benchmarkProducer.py bench4 "localhost:29092" 120 & python3 benchmarkConsumer.py bench4 "localhost:29092" 120 &`

Different configurations:
 - Partitions and Replication Factor are Topic-specific and should be specified when creating the topic
 - Synchronous mode:
 Edit benchmarkProducer.py and add "sync=True" to the producer constructor
 (line 60)
 - Batch Size:
 Edit benchmarkProducer.py and add "min_queued_messages = <number>" to the producer constructor
 (line 60)
 - Fecth Size:
 Edit benchmarkConsumer.py and add "fetch_min_bytes=3000" to the consumer constructor (line 57)

