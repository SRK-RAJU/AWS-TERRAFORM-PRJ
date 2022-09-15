#! /bin/bash
#sudo apt update
#sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
#curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
#sudo apt update
#sudo apt-get install docker-ce
#sudo systemctl start docker
#sudo systemctl enable docker
#sudo groupadd docker
#sudo usermod -aG docker ubuntu
#sudo docker pull nginx:latest
#sudo docker run --name mynginx1 -p 80:80 -d nginx
#!/bin/bash
#    set -ex
#    sudo yum update -y
#    sudo amazon-linux-extras install docker -y
#    sudo service docker start
#    sudo usermod -a -G docker ec2-user
#    sudo curl -L https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
#    sudo chmod +x /usr/local/bin/docker-compose

  "{" sudo yum update -y "}"
  "{" sudo amazon-linux-extras install docker "}"
  "{" sudo service docker start "}"
   sudo systemctl enable docker
   usermod -a -G docker ec2-user