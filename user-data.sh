#! /bin/bash
sudo yum update -y
echo "Install Docker engine"
sudo yum install -y docker
sudo sudo chkconfig docker on
sudo service dock er start
sudo usermod -a -G docker ec2-user
sudo docker pull nginx:latest
sudo docker run --name mynginx1 -p 60:80 -d nginx
