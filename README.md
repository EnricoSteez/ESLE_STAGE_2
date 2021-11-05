# ESLE_STAGE_2
Stage 2 of the Large Scale Engineering project (2021/2022)

This procedure assumes that you already have AWS CLI installed and configured, as well as Docker.

First, create a new docker context to deploy the infrastructure on AWS instead of the default platform (localhost):

`docker context create ecs <nameofcontext>`

Deploy 4 EC2 machines with `terraform apply`. 

Run the ansible playbook to provision them: 

`ansible-playbook playbook.yml --ask-vault-pass --tags create_ec2 `.

Get the DNS for each machine, either on the AWS EC2 dashboard or by running 

`ansible-playbook playbook.yml --ask-vault-pass`.

Connect to the machines to test whether the Kafka installation was successful: 

`ssh -i ~/.ssh/my_aws <my-instance-user-name>@<my-instance-public-dns-name>`


