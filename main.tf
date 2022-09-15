#module "vpc" {
#  source          = "./vpc"
#  access_ip       = var.access_ip
#  vpc_cidr        = local.vpc_cidr
#  security_groups = local.security_groups
#}
#module "ec2" {
#  source        = "./ec2"
#  public_sg     = module.network.public_sg
#  public_subnet = module.network.public-sub-1
#}



resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.dev_key.public_key_openssh

  provisioner "local-exec" {    # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.generated_key_name}'.pem
      chmod 400 ./'${var.generated_key_name}'.pem
    EOT
  }

}

// Generate the SSH keypair that we’ll use to configure the EC2 instance.
// After that, write the private key to a local file and upload the public key to AWS
#resource "tls_private_key" "key" {
#  algorithm = "RSA"
#  rsa_bits  = 4096
#}
#resource "local_file" "private_key" {
#  filename          = "zwaw.pem"
#  sensitive_content = tls_private_key.key.private_key_pem
#  file_permission   = "0400"
#}
#resource "aws_key_pair" "key_pair" {
#  key_name   = "zwaw"
#  public_key = tls_private_key.key.public_key_openssh
#}
#Create a new EC2 launch configuration
#resource "aws_instance" "ec2_public" {
#  ami                    = "ami-05fa00d4c63e32376"
#  instance_type               = var.ec2-type
#  key_name                    = "${var.key_name}"
#  security_groups = [ aws_security_group.allow-sg-pub.id ]
##  security_groups             = ["${aws_security_group.ssh-security-group.id}"]
##  subnet_id                   = "${aws_subnet.public-subnet-1.id}"
#  subnet_id = aws_subnet.public-sub.id
#  associate_public_ip_address = true
#  #user_data                   = "${data.template_file.provision.rendered}"
#  #iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
#  lifecycle {
#    create_before_destroy = true
#  }
#  tags = merge(
#    local.tags,
#    {
#      #    Name = "pub-ec2-${count.index}"
#      Name="pub-ec2"
#      name= "devops-raju"
#    })
##  tags = {
##    "Name" = "EC2-PUBLIC"
##  }
#  # Copies the ssh key file to home dir
#  # Copies the ssh key file to home dir
#  provisioner "file" {
#    source      = "./${var.key_name}.pem"
#    destination = "/home/ec2-user/${var.key_name}.pem"
#    connection {
#      type        = "ssh"
#      user        = "ec2-user"
#      private_key = file("${var.key_name}.pem")
#      host        = self.public_ip
#    }
#  }
#  //chmod key 400 on EC2 instance
#  provisioner "remote-exec" {
#    inline = ["chmod 400 ~/${var.key_name}.pem"]
#    connection {
#      type        = "ssh"
#      user        = "ec2-user"
#      private_key = file("${var.key_name}.pem")
#      host        = self.public_ip
#    }
#  }
#}
##Create a new EC2 launch configuration
#resource "aws_instance" "ec2_private" {
#  #name_prefix                 = "terraform-example-web-instance"
#  ami                    = "ami-05fa00d4c63e32376"
##  instance_type               = "${var.instance_type}"
#  instance_type = var.ec2-type
#  key_name                    = "${var.key_name}"
#  security_groups = [ aws_security_group.allow-sg-pvt.id ]
##  security_groups             = ["${aws_security_group.webserver-security-group.id}"]
#  subnet_id = aws_subnet.private-sub.id
##  subnet_id                   = "${aws_subnet.private-subnet-1.id}"
#  associate_public_ip_address = false
#  #user_data                   = "${data.template_file.provision.rendered}"
#  #iam_instance_profile = "${aws_iam_instance_profile.some_profile.id}"
#  lifecycle {
#    create_before_destroy = true
#  }
#
#  tags = merge(
#        local.tags,
#        {
#          #      Name = "pvt-ec2-${count.index}"
#          Name="pvt-ec2"
#          name= "devops-raju"
#        })
##  tags = {
##    "Name" = "EC2-Private"
##  }
#}

## Set the required provider and versions
#terraform {
#  required_providers {
#    # We recommend pinning to the specific version of the Docker Provider you're using
#    # since new versions are released frequently
#    docker = {
#      source  = "kreuzwerker/docker"
#      version = "2.21.0"
#    }
#  }
#}
#
## Configure the docker provider
#provider "docker" {
#}
#
## Create a docker image resource
## -> docker pull nginx:latest
#resource "docker_image" "nginx" {
#  name         = "nginx:latest"
#  keep_locally = true
#}
#
## Create a docker container resource
## -> same as 'docker run --name nginx -p8080:80 -d nginx:latest'
#resource "docker_container" "nginx" {
#  name    = "nginx"
#  image   = docker_image.nginx.image_id
#
#  ports {
#    external = 8080
#    internal = 80
#  }
#}
#
## Or create a service resource
## -> same as 'docker service create -d -p 8081:80 --name nginx-service --replicas 2 nginx:latest'
#resource "docker_service" "nginx_service" {
#  name = "nginx-service"
#  task_spec {
#    container_spec {
#      image = docker_image.nginx.repo_digest
#    }
#  }
#
#  mode {
#    replicated {
#      replicas = 2
#    }
#  }
#
#  endpoint_spec {
#    ports {
#      published_port = 8081
#      target_port    = 80
#    }
#  }
#}


resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.latest
  name  = "tutorial"
  ports {
    internal = 80
    external = 8000
  }
}

resource "aws_instance" "app_server-pub" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.ec2-type
  key_name = var.generated_key_name
  security_groups = [ aws_security_group.allow-sg-pub.id ]
  subnet_id = aws_subnet.public-sub.id
#  associate_public_ip_address = true
#  user_data = "user.tpl"
#  user_data = "${file("user.tpl")}"
  #  count = 2
  user_data = <<-EOF
#! /bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker pull nginx:latest
sudo docker run --name mynginx1 -p 70:80 -d nginx

sudo yum -y update

echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

echo "Install Maven"
sudo yum install -y maven

echo "Install git"
sudo yum install -y git

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
sudo sudo chkconfig docker on

echo "Install Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo usermod -a -G docker jenkins
sudo chkconfig jenkins on

echo "Start Docker & Jenkins services"
sudo service docker start
sudo service jenkins start
sudo wget https://get.jenkins.io/war-stable/2.361.1/jenkins.war
sudo java -jar jenkins.war

EOF


  tags = merge(
    local.tags,
    {
      #    Name = "pub-ec2-${count.index}"
      Name="pub-ec2"
      name= "devops-raju"
    })
}

#resource "aws_instance" "app_server-pub-2" {
#  ami           = "ami-05fa00d4c63e32376"
#  instance_type = var.ec2-type
#  key_name = var.key-pair
#  security_groups = [ aws_security_group.allow-sg-pub.id ]
#  subnet_id = aws_subnet.public-sub.id
#  associate_public_ip_address = true
#  user_data = "user.tpl"
#  #  count = 2
#
#  tags = merge(
#    local.tags,
#    {
#      #    Name = "pub-ec2-${count.index}"
#      Name="pub-ec2-2"
#      name= "devops-raju"
#    })
#}

#   #! /bin/bash
#  sudo yum update -y
#sudo yum install -y docker
#sudo service docker start
#sudo usermod -a -G docker ec2-user
#sudo docker pull nginx:latest
#sudo docker run --name mynginx1 -p 80:80 -d nginx
#docker ps -a
#EOF

resource "aws_instance" "app_server-pvt" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.ec2-type
  key_name = var.generated_key_name
  security_groups = [ aws_security_group.allow-sg-pvt.id ]
  subnet_id = aws_subnet.private-sub.id
#  associate_public_ip_address = true
# user_data = "user.tpl"
#  user_data = "${file("user.tpl")}"
#  user_data = "user.sh"
  #  count = 2
  user_data = <<-EOF
            #! /bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker pull nginx:latest
sudo docker run --name mynginx3 -p 70:80 -d nginx


sudo yum -y update

echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

echo "Install Maven"
sudo yum install -y maven

echo "Install git"
sudo yum install -y git

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
sudo sudo chkconfig docker on

echo "Install Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo usermod -a -G docker jenkins
sudo chkconfig jenkins on

echo "Start Docker & Jenkins services"
sudo service docker start
sudo service jenkins start
sudo wget https://get.jenkins.io/war-stable/2.361.1/jenkins.war
sudo java -jar jenkins.war
EOF


  tags = merge(
    local.tags,
    {
      #      Name = "pvt-ec2-${count.index}"
      Name="pvt-ec2"
      name= "devops-raju"
    })
}

#              #!/bin/bash
#              yum -y install httpd
#              echo "Hello, from Terraform" > /var/www/html/index.html
#              service httpd start
#              chkconfig httpd on
#              EOF


resource "aws_launch_configuration" "launch_config" {
  name_prefix                 = "tf-auto-scale-instance"

  image_id = "ami-05fa00d4c63e32376"

#  image_id                    = "${lookup(var.amis, var.region)}"
#  image_id                    = ["${ lookup(var.amis, var.region)}"]
#  image_id = "ami-05fa00d4c63e32376"
  instance_type               = var.instance_type
#   instance_type = "t2.micro"
#  key_name                    = "${aws_key_pair.deployer.id}"
  key_name = var.generated_key_name
  security_groups             = [aws_security_group.default.id]

  associate_public_ip_address = true
  user_data = <<-EOF
#! /bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker pull nginx:latest
sudo docker run --name mynginx2 -p 70:80 -d nginx

sudo yum -y update

echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

echo "Install Maven"
sudo yum install -y maven

echo "Install git"
sudo yum install -y git

echo "Install Docker engine"
sudo yum update -y
sudo yum install docker -y
sudo sudo chkconfig docker on

echo "Install Jenkins"
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo usermod -a -G docker jenkins
sudo chkconfig jenkins on

echo "Start Docker & Jenkins services"
sudo service docker start
sudo service jenkins start
sudo wget https://get.jenkins.io/war-stable/2.361.1/jenkins.war
sudo java -jar jenkins.war
EOF

  #       user_data = <<-EOF
#                #!/bin/bash
#                sudo apt-get update
#sudo apt-get install -y apache2
#sudo systemctl start apache2
#sudo systemctl enable apache2
#
#echo "<h1>Deployed via Terraform</h1>"  sudo tee /var/www/html/index.html
#
#sudo systemctl status apache2
#
##                echo "Hello, from Terraform" > /var/www/html/index.html
##                service httpd start
##                chkconfig httpd on
#                EOF
# user_data = << EOF
#            #! /bin/bash
#sudo apt-get update
#sudo apt-get install -y apache2
#sudo systemctl start apache2
#sudo systemctl enable apache2
#echo "<h1>Deployed via Terraform</h1>"
#sudo tee /var/www/html/index.html
#EOF

lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
   name = "tf-as-grp"
  launch_configuration = aws_launch_configuration.launch_config.id
  min_size             = var.autoscaling_group_min_size
  max_size             = var.autoscaling_group_max_size
  force_delete              = true
  health_check_grace_period = 300
  health_check_type         = "ELB"
#  placement_group           = aws_launch_configuration.launch_config.id
  target_group_arns    = [aws_alb_target_group.group.arn]
  vpc_zone_identifier  = [aws_subnet.public-sub.id,aws_subnet.private-sub.id]

  tag {
    key                 = "Name"
    value               = "tf-autoscaling-group"
    propagate_at_launch = true
  }
}






resource "aws_vpc" "my_vpc" {
  cidr_block = "172.31.0.0/26"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "my-vpc"
  }
}
#creating elastic ip
resource "aws_eip" "nat-eip" {
  vpc=true
  tags = {
    Name="EIP"
  }
}

resource "aws_security_group" "alb" {
  name        = "tf_alb_sg"
  description = "Terraform load balancer security group"
  vpc_id      = aws_vpc.my_vpc.id

    ingress {
from_port   = 443
to_port     = 443
protocol    = "tcp"
cidr_blocks = ["172.0.0.0/26"]
}

ingress {
from_port   = 80
to_port     = 80
protocol    = "tcp"
cidr_blocks = ["172.0.0.0/26"]
}

# Allow all outbound traffic.
egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
Name = "alb-sg"
}
}

resource "aws_alb" "alb" {
  name            = "terraform-alb"
  security_groups = [aws_security_group.alb.id]
  subnets         = [aws_subnet.public-sub.id,aws_subnet.private-sub.id]
  tags = {
    Name = "terraform-alb"
  }
}



resource "aws_lb" "nlb" {
  name               = "nlb-lb-tf"
  internal           = false
  load_balancer_type = "network"
#  security_groups = [aws_security_group.allow-sg-pvt.id]
  subnets            = [aws_subnet.public-sub.id,aws_subnet.private-sub.id]

  enable_deletion_protection = false


  tags = {
    Name="NLB-terraform"
    Environment = "production"
  }
}
#### aws alb target group
resource "aws_alb_target_group" "group" {
  name     = "tf-alb-target"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.my_vpc.id}"
  stickiness {
    type = "lb_cookie"
  }
  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/login"
    port = 80
  }
}
### alb target group http listener
resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.group.arn}"
    type             = "forward"
  }
}

### alb target group https listener
#resource "aws_alb_listener" "listener_https" {
#  load_balancer_arn = "${aws_alb.alb.arn}"
#  port              = "443"
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::235048029161:user/raju"
#  default_action {
#    target_group_arn = "${aws_alb_target_group.group.arn}"
#    type             = "forward"
#  }
#}



#resource "aws_route_table" "my-pub-rt" {
#  vpc_id =aws_vpc.my_vpc.id
#  route {
#    cidr_block = "0.0.0.0/0"
#    nat_gateway_id = aws_nat_gateway.dev-nat.id
#  }
#  tags =merge(merge
#    local.tags,
#    {
#      Name="pub-RT"
#    })
#}
############ route53 record

#resource "aws_route53_record" "terraform" {
#  zone_id = "${data.aws_route53_zone.zone.zone_id}"
#  name    = "terraform.${var.route53_hosted_zone_name}"
#  type    = "A"
#  alias {
#    name                   = "${aws_alb.alb.dns_name}"
#    zone_id                = "${aws_alb.alb.zone_id}"
#    evaluate_target_health = true
#  }
#}
#
#
#data "aws_route53_zone" "zone" {
#  name = "${var.route53_hosted_zone_name}"
#}
#
#variable "route53_hosted_zone_name" {}
#variable "allowed_cidr_blocks" {
#  type = "list"
#}



