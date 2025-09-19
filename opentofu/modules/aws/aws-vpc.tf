resource "aws_vpc" "groot_net_vpc" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "groot-net VPC"
  }
}

resource "aws_subnet" "groot_net_vpc_public_subnet" {
  vpc_id     = aws_vpc.groot_net_vpc.id
  cidr_block = "10.0.0.0/25"

  tags = {
    Name = "groot-net public subnet"
  }
}

resource "aws_subnet" "groot_net_vpc_private_subnet" {
  vpc_id     = aws_vpc.groot_net_vpc.id
  cidr_block = "10.0.0.128/25"

  tags = {
    Name = "groot-net private subnet"
  }
}

resource "aws_internet_gateway" "groot_net_vpc_igw" {
  vpc_id = aws_vpc.groot_net_vpc.id

  tags = {
    Name = "groot-net VPC internet gateway"
  }
}

resource "aws_route_table" "groot_net_vpc_public_rtb" {
  vpc_id = aws_vpc.groot_net_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.groot_net_vpc_igw.id
  }

  tags = {
    Name = "groot-net VPC public route table"
  }

}

resource "aws_route_table" "groot_net_vpc_private_rtb" {
  vpc_id = aws_vpc.groot_net_vpc.id

  tags = {
    Name = "groot-net VPC private route table"
  }
}

resource "aws_route_table_association" "groot_net_vpc_public_rtb_assoc" {
  subnet_id      = aws_subnet.groot_net_vpc_public_subnet.id
  route_table_id = aws_route_table.groot_net_vpc_public_rtb.id
}

resource "aws_route_table_association" "groot_net_vpc_private_rtb_assoc" {
  subnet_id      = aws_subnet.groot_net_vpc_private_subnet.id
  route_table_id = aws_route_table.groot_net_vpc_private_rtb.id
}

resource "aws_vpc_endpoint" "groot_net_vpc_s3_gateway_endpoint" {
  vpc_id            = aws_vpc.groot_net_vpc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.eu-west-1.s3"
  service_region    = "eu-west-1"
  route_table_ids   = [aws_route_table.groot_net_vpc_public_rtb.id, aws_route_table.groot_net_vpc_private_rtb.id]
  ip_address_type   = "ipv4"

  tags = {
    Name = "groot-net VPC S3 Gateway Endpoint"
  }
}

resource "aws_vpc_endpoint" "groot_net_vpc_dynamodb_gateway_endpoint" {
  vpc_id            = aws_vpc.groot_net_vpc.id
  vpc_endpoint_type = "Gateway"
  service_name      = "com.amazonaws.eu-west-1.dynamodb"
  service_region    = "eu-west-1"
  route_table_ids   = [aws_route_table.groot_net_vpc_public_rtb.id, aws_route_table.groot_net_vpc_private_rtb.id]
  ip_address_type   = "ipv4"

  tags = {
    Name = "groot-net VPC DynamoDB Gateway Endpoint"
  }
}