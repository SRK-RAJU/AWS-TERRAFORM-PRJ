#! /bin/bash
sudo yum update
sudo yum install -y docker
sudo service docker start
echo "docker started"
sudo usermod -aG docker ec2-user
sudo docker pull nginx:latest
echo "docker nginx install"
sudo docker run --name mynginx1 -p 8087:8080 -d nginx
echo "docker run mynginx1"