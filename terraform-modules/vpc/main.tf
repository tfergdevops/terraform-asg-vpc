resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block #var

  tags = {
    Name = var.vpc_name #var
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_subnet" "sub-a" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.avail_zone[0]        #var
  cidr_block        = var.subnet_cidr_block[0] #var
  tags = {
    Name = var.subnet_names[0] #var
  }
}

resource "aws_subnet" "sub-b" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.avail_zone[1]        #var
  cidr_block        = var.subnet_cidr_block[1] #var
  tags = {
    Name = var.subnet_names[1] #var
  }
}

resource "aws_subnet" "sub-c" {
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.avail_zone[2]        #var
  cidr_block        = var.subnet_cidr_block[2] #var
  tags = {
    Name = var.subnet_names[2] #var
  }
}

resource "aws_default_route_table" "drt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}