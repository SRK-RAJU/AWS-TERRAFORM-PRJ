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

resource "aws_instance" "app_server-pub" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.ec2-type
  key_name = var.key-pair
  security_groups = [ aws_security_group.allow-sg-pub.id ]
  subnet_id = aws_subnet.public-sub.id
  associate_public_ip_address = true
  user_data = "user.tpl"
  #  count = 2

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

resource "aws_instance" "app_server-pvt" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.ec2-type
  key_name = var.key-pair
  security_groups = [ aws_security_group.allow-sg-pvt.id ]
  subnet_id = aws_subnet.private-sub.id
  associate_public_ip_address = true
  user_data = "user.tpl"
  #  count = 2

  tags = merge(
    local.tags,
    {
      #      Name = "pvt-ec2-${count.index}"
      Name="pvt-ec2"
      name= "devops-raju"
    })
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
}

resource "aws_security_group" "alb" {
  name        = "terraform_alb_security_group"
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
  subnets         = [aws_subnet.private-sub.*.id]
  tags = {
    Name = "terraform-alb"
  }
}




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

