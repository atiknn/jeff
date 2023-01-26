locals {
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = ["10.0.0.0/18", "10.0.64.0/18"]
  private_subnet_cidr = ["10.0.128.0/18", "10.0.192.0/18"]  
}
# Configure the AWS Provider 

# Create a -  VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "${var.environment_code}_main_vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = element(local.public_subnet_cidr, 1)

  tags = {
    Name = "${var.environment_code}_public_subnet_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = element(local.public_subnet_cidr, 2)

  tags = {
    Name = "${var.environment_code}_public_subnet_2"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = element(local.private_subnet_cidr, 1)

  tags = {
    Name = "${var.environment_code}_private_subnet_1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = element(local.private_subnet_cidr, 2)

  tags = {
    Name = "${var.environment_code}_private_subnet_2"
  }
}

resource "aws_internet_gateway" "main_internetgateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment_code}_main_internetgateway"
  }
}

resource "aws_nat_gateway" "aws_nat_gateway_1" {
  allocation_id = aws_eip.aws_eip_1.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "${var.environment_code}_aws_nat_gateway_1"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main_internetgateway]
}

resource "aws_nat_gateway" "aws_nat_gateway_2" {
  allocation_id = aws_eip.aws_eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags = {
    Name = "${var.environment_code}_aws_nat_gateway_2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.main_internetgateway]
}

resource "aws_route_table" "public_route_table" { # Creating RT for Public Subnet
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0" # Traffic from Public Subnet reaches Internet via Internet Gateway
    gateway_id = aws_internet_gateway.main_internetgateway.id
  }

  tags = {
    Name = "${var.environment_code}_public_route_table"
  }
}

resource "aws_route_table" "private_route_table_1" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.aws_nat_gateway_1.id
  }

  tags = {
    Name = "${var.environment_code}_private_route_table_1"
  }
}

resource "aws_route_table" "private_route_table_2" { # Creating RT for Private Subnet
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.aws_nat_gateway_2.id
  }

  tags = {
    Name = "${var.environment_code}_private_route_table_2"
  }
}

resource "aws_route_table_association" "public_subnet_1_to_public_route_table" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_2_to_public_route_table" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_1_to_public_route_table" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table_1.id
}

resource "aws_route_table_association" "private_subnet_2_to_public_route_table" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}

resource "aws_eip" "aws_eip_1" {
  vpc = true

  tags = {
    Name = "${var.environment_code}_aws_eip_1"
  }
}

resource "aws_eip" "aws_eip_2" {
  vpc = true

  tags = {
    Name = "${var.environment_code}_aws_eip_2"
  }
}
