#! /bin/bash

 yum update -y

 yum install -y docker

sudo service docker start

#echo "docker started"

sudo usermod -aG docker $USER
# usermod -aG docker ec2-user

 docker pull nginx:latest
#echo "docker nginx install"
 docker run --name mynginx1 -p 8087:8080 -d nginx
#echo "docker run mynginx1"