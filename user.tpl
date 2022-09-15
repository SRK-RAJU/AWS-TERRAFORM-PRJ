#! /bin/bash

sudo yum update -y

sudo yum install docker





sudo usermod -a -G docker ec2-user

id ec2-user

newgrp docker



sudo systemctl enable docker.service

sudo systemctl start docker.service

docker pull nginx:latest

docker run --name mynginx1 -p 80:80 -d nginx
