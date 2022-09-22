#resource "aws_instance" "tf_server" {
#  ami           = "ami-07fb0efa6866bc7b4"
#  instance_type = "t2.micro"
#  subnet_id = [aws_subnet.al_pubsub.id,aws_subnet.al_pvtsub.id]
#  key_name      = "aws_key"
#  tags = {
#    Name = "ALserver by Terraform"
#  }
#}
#
#
##creating vpc
#
#resource "aws_vpc" "ALserver_vpc" {
#
#  cidr_block           = "192.0.0.0/24"
#  instance_tenancy     = "default"
#  enable_dns_hostnames = "true"
#
#  tags = {
#    Name = "ALser_vpc"
#  }
#}
#
#
##creating pub-sub net
#
#resource "aws_subnet" "al_pubsub" {
#  vpc_id                                      = aws_vpc.ALserver_vpc.id
#  cidr_block                                  = "192.0.0.0/26"
#  avalability_zone                            = "ap-south-1"
#  enable_resource_name_dns_a_record_on_launch = "true"
#  map_public_ip_on_launch                     = "true"
#
#  tags = {
#    Name = "AL_pubsub-1"
#
#  }
#}
#
##creating pvt sub net
#
#resource "aws_subnet" "al_pvtsub" {
#  vpc_id                                      = aws_vpc.ALserver_vpc.id
#  cidr_block                                  = "192.0.0.32/26"
#  avalability_zone                            = "ap-south-1"
#  enable_resource_name_dns_a_record_on_launch = "true"
#
#  tags = {
#    Name = "AL_pvtsub-1
#
#  }
#}
#


