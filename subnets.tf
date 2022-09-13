#Creating Public subnet

resource "aws_subnet" "public-sub" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.31.0.0/28"
  availability_zone = "us-east-1a"
  enable_resource_name_dns_a_record_on_launch="true"
  map_public_ip_on_launch = "true"
  tags = merge(
    local.tags,
    {
      Name = "my_vpc-pub-sub"
    })
}
#resource "aws_subnet" "public-sub-2" {
#  vpc_id     = aws_vpc.my_vpc.id
#  cidr_block = "172.31.0.16/28"
#  availability_zone = "us-east-1a"
#  enable_resource_name_dns_a_record_on_launch="true"
#  map_public_ip_on_launch = "true"
#  tags = merge(
#    local.tags,
#    {
#      Name = "my_vpc-pvt-sub-2"
#    })
#}

#creating private subnet

resource "aws_subnet" "private-sub" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "172.31.0.32/28"
  availability_zone = "us-east-1b"
  enable_resource_name_dns_a_record_on_launch="true"
  tags = merge(
    local.tags,
    {
      Name = "my_vpc-pvt-sub"
    })
}
#resource "aws_subnet" "private-sub-2" {
#  vpc_id     = aws_vpc.my_vpc.id
#  cidr_block = "172.31.0.48/28"
#  availability_zone = "us-east-1b"
#  enable_resource_name_dns_a_record_on_launch="true"
#  tags = merge(
#    local.tags,
#    {
#      Name = "my_vpc-pvt-sub-2"
#    })
#}
#creating route tables




resource "aws_internet_gateway" "my_vpc_igw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = merge(
    local.tags,{
      Name = "my-vpc-igw"
    })
}

#resource "aws_internet_gateway_attachment" "igw-attach"{
#  internet_gateway_id = aws_internet_gateway.my_vpc_igw.id
#  vpc_id              = aws_vpc.my_vpc.id
#}

#resource "aws_internet_gateway_attachment" "igw-attach" {
#  internet_gateway_id=aws_internet_gateway.my_vpc_igw.id
#  vpc_id=aws_vpc.my_vpc.id
#}
resource "aws_nat_gateway" "dev-nat" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id = aws_subnet.public-sub.id
  tags={
    Name="Nat Gateway"
  }
  depends_on = [aws_internet_gateway.my_vpc_igw]
}


