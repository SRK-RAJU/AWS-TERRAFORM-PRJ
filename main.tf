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

resource "aws_instance" "app_server-pub-1" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.ec2-type
  key_name = var.key-pair
  security_groups = [ aws_security_group.allow-sg-pub.id ]
  subnet_id = aws_subnet.public-sub-1.id
  associate_public_ip_address = true
  user_data = "user.tpl"
  #  count = 2

  tags = merge(
    local.tags,
    {
      #    Name = "pub-ec2-${count.index}"
      Name="pub-ec2-1"
      name= "devops-raju"
    })
}

resource "aws_instance" "app_server-pub-2" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.ec2-type
  key_name = var.key-pair
  security_groups = [ aws_security_group.allow-sg-pub.id ]
  subnet_id = aws_subnet.public-sub-2.id
  associate_public_ip_address = true
  user_data = "user.tpl"
  #  count = 2

  tags = merge(
    local.tags,
    {
      #    Name = "pub-ec2-${count.index}"
      Name="pub-ec2-2"
      name= "devops-raju"
    })
}

resource "aws_instance" "app_server-pvt" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = var.ec2-type
  key_name = var.key-pair
  security_groups = [ aws_security_group.allow-sg-pvt.id ]
  subnet_id = aws_subnet.private-sub-1.id
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

#Creating Public subnet

resource "aws_subnet" "public-sub-1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.31.0.0/28"
  availability_zone = "us-east-1a"
  enable_resource_name_dns_a_record_on_launch="true"
  map_public_ip_on_launch = "true"
  tags = merge(
    local.tags,
    {
      Name = "my_vpc-pub-sub-1"
    })
}
resource "aws_subnet" "public-sub-2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.31.0.16/28"
  availability_zone = "us-east-1a"
  enable_resource_name_dns_a_record_on_launch="true"
  map_public_ip_on_launch = "true"
  tags = merge(
    local.tags,
    {
      Name = "my_vpc-pvt-sub-2"
    })
}

#creating private subnet

resource "aws_subnet" "private-sub-1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.31.0.32/28"
  availability_zone = "us-east-1b"
  enable_resource_name_dns_a_record_on_launch="true"
  tags = merge(
    local.tags,
    {
      Name = "my_vpc-pvt-sub-1"
    })
}
resource "aws_subnet" "private-sub-2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.31.0.48/28"
  availability_zone = "us-east-1b"
  enable_resource_name_dns_a_record_on_launch="true"
  tags = merge(
    local.tags,
    {
      Name = "my_vpc-pvt-sub-2"
    })
}
#creating route tables

resource "aws_route_table" "my-pub-rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_vpc_igw.id
  }

  tags = merge(
    local.tags,
    {
      Name = "pub-rt"
    })
}
#creating elastic ip
resource "aws_eip" "nat-eip" {
  vpc=true
}

resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    local.tags,{
      Name = "my-vpc-igw"
    })
}

resource "aws_internet_gateway_attachment" "igw-attach" {
  internet_gateway_id=aws_internet_gateway.my_vpc_igw.id
  vpc_id=aws_vpc.my_vpc.id
}
resource "aws_nat_gateway" "dev-nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.public-sub-1.id
  tags={
    Name="Nat Gateway"
  }
  depends_on = [aws_internet_gateway.my_vpc_igw]
}


resource "aws_route_table" "my-pvt-rt" {
  vpc_id =aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev-nat.id
  }
  tags =merge(merge
    local.tags,
    {
      Name="pvt-RT"
    })
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

resource "aws_route_table_association" "sub-pub" {
  subnet_id = [aws_subnet.public-sub-1.id,aws_subnet.public-sub-2.id]
  route_table_id = aws_route_table.my-pub-rt.id
}
resource "aws_route_table_association" "sub-pvt" {
  subnet_id =[ aws_subnet.private-sub-1.id,aws_subnet.private-sub-2.id]
  route_table_id = aws_route_table.my-pvt-rt.id
}


