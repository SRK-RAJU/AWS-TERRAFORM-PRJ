resource "aws_route_table" "my-pvt-rt" {
  vpc_id =aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.dev-nat.id
  }
  tags =merge(
    local.tags,
    {
      Name="pvt-RT"
    })
}

resource "aws_route_table_association" "sub-pub" {
  subnet_id = [aws_subnet.public-sub-1.id,aws_subnet.public-sub-2.id]
  route_table_id = aws_route_table.my-pub-rt.id
}
resource "aws_route_table_association" "sub-pvt" {
  subnet_id =[ aws_subnet.private-sub-1.id,aws_subnet.private-sub-2.id]
  route_table_id = aws_route_table.my-pvt-rt.id
}
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



