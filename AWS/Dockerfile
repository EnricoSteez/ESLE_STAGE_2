# Dockerfile
FROM ubuntu:latest
# Install jdk 
RUN apt-get update && apt-get install openjdk-8-jre -y 
# Unzip kafka zip and rename at kafka
ENV kafka_version=2.13-3.0.0 
ADD ./kafka ./kafka
ENV KAFKA_HEAP_OPTS="-Xmx256M -Xms256M"