### vpc ###
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true

  tags = var.vpc_tags
}

### subnets ###
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub_subnet_cidr
  availability_zone       = var.pub_subnet_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.pub_subnet_name
    Tier = "Public"
  }
}


resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.priv_sub1_cidr
  availability_zone = var.priv_sub1_az

  tags = {
    Name = var.priv_sub1_name
    Tier = "Private"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.priv_sub2_cidr
  availability_zone = var.priv_sub2_az

  tags = {
    Name = var.priv_sub2_name
    Tier = "Private"
  }
}

resource "aws_subnet" "private_subnet3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.priv_sub3_cidr
  availability_zone = var.priv_sub3_az

  tags = {
    Name = var.priv_sub3_name
    Tier = "Private"
  }
}

### igw ###
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route"
  }
}

resource "aws_route_table_association" "public_subnet_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id
}

### eip ### 
resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = var.eip_name
  }
}

### nat ###
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = var.natgw_name
  }
}

resource "aws_route_table" "nat_route" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "private-subnet-route-table"
  }
}
resource "aws_route_table_association" "nat_rt_assoc1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.nat_route.id
}

resource "aws_route_table_association" "nat_rt_assoc2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.nat_route.id
}
resource "aws_route_table_association" "nat_rt_assoc3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.nat_route.id
}

### rds subnet group ###

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.rds_subnet_group_name
  subnet_ids = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id, aws_subnet.private_subnet3.id]

  tags = {
    Name = var.rds_subnet_group_name
  }
}