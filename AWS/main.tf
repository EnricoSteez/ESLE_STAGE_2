terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "kafka_node" {

  ami           = "ami-083654bd07b5da81d"
  instance_type = "t3.micro"
  count         = 3
  key_name      = "esle"
  tags = {
    Name = "Broker${count.index}"
  }

}
resource "aws_instance" "bench_station" {

  ami           = "ami-083654bd07b5da81d"
  instance_type = "t3.micro"
  count         = 1
  key_name      = "esle"
  tags = {
    Name = "Benchmark"
  }

}
