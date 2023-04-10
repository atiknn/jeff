locals {
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = ["10.0.0.0/18", "10.0.64.0/18"]
  private_subnet_cidr = ["10.0.128.0/18", "10.0.192.0/18"]
  availibity_zone = ["us-east-1a","us-east-1c"]
}
# Configure the AWS Provider 

# Create a -  VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = local.vpc_cidr

  tags = {
    Name = "${var.environment_code}_main_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(local.public_subnet_cidr)

  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = local.public_subnet_cidr[count.index]
  availability_zone =  local.availibity_zone[count.index]
  tags = {
    Name = "${var.environment_code}_public_subnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(local.private_subnet_cidr)

  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = local.private_subnet_cidr[count.index]
  availability_zone =  local.availibity_zone[count.index]
  tags = {
    Name = "${var.environment_code}_private_subnet_${count.index}"
  }
}

resource "aws_internet_gateway" "main_internetgateway" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.environment_code}_main_internetgateway"
  }
}

resource "aws_nat_gateway" "aws_nat_gateway" {
  count = length(local.public_subnet_cidr)

  allocation_id = aws_eip.aws_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "${var.environment_code}_aws_nat_gateway_${count.index}"
  }

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

resource "aws_route_table" "private_route_table" { # Creating RT for Private Subnet
  count = length(local.private_subnet_cidr)

  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0" # Traffic from Private Subnet reaches Internet via NAT Gateway
    nat_gateway_id = aws_nat_gateway.aws_nat_gateway[count.index].id
  }

  tags = {
    Name = "${var.environment_code}_private_route_table_${count.index}"
  }
}

resource "aws_route_table_association" "public_subnet_to_public_route_table" {
  count = length(local.public_subnet_cidr)

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_to_public_route_table" {
  count = length(local.private_subnet_cidr)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[count.index].id
}

resource "aws_eip" "aws_eip" {
  count = length(local.public_subnet_cidr)
  vpc   = true

  tags = {
    Name = "${var.environment_code}_aws_eip_${count.index}"
  }
}
