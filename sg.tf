resource "aws_security_group" "allow-sg-pub" {
  name        = "allow-sg-pub"
  description = "Allow SSH inbound connections"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allowing all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_sg-pub"
  }

}

resource "aws_security_group" "allow-sg-pvt" {
  name        = "allow-sg-pvt"
  description = "Allow SSH inbound connections"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    description = "Allowing with in vpc "
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["172.31.0.0/26"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_sg-pvt"
  }

}
