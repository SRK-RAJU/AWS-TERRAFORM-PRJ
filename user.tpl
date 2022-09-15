#! /bin/bash

sudo yum update -y

sudo yum install docker

# yum install -y docker

#sudo service docker start

#echo "docker started"

sudo usermod -a -G docker ec2-user

id ec2-user

newgrp docker
# usermod -aG docker ec2-user


sudo systemctl enable docker.service

sudo systemctl start docker.service

docker pull nginx:latest
#echo "docker nginx install"
docker run --name mynginx1 -p 80:80 -d nginx
#echo "docker run mynginx1"