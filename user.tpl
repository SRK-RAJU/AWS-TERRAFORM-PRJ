#! /bin/bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   ./get-docker.sh

   sudo yum update -y
    sudo amazon-linux-extras install docker
  sudo service docker start
   sudo systemctl enable docker
   usermod -a -G docker ec2-user