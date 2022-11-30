# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "iselab-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "iselab-igw"
  }
}

# Create an Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
      Name = "iselab-eip"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = "${element(aws_subnet.public_subnet.*.id, 0)}"
  depends_on = [aws_internet_gateway.igw]
  tags = {
      Name = "iselab-natgw"
  }
}

# Create two Public subnets; one for each AZ
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.public_subnets_cidr)
  cidr_block = element(var.public_subnets_cidr, count.index)
  availability_zone = element(var.iselab_az, count.index)
  map_public_ip_on_launch = true
  tags = {
      Name = "iselab-${element(var.iselab_az, count.index)}-public-subnet"
  }
}

# Create two Private subnets; one for each AZ
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.private_subnets_cidr)
  cidr_block = element(var.private_subnets_cidr, count.index)
  availability_zone = element(var.iselab_az, count.index)
  map_public_ip_on_launch = false
  tags = {
      Name = "iselab-${element(var.iselab_az, count.index)}-private-subnet"
  }
}

# Create a routing table for private subnets
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc.id
  tags = {
      Name = "iselab-private-route-table"
  }
}

# Create a routing table for public subnets
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc.id
  tags = {
      Name = "iselab-public-route-table"
  }
}

# Add a default route for the Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

# Add a default route for the NAT Gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id = aws_route_table.private_route.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.natgw.id
}

# Add bindings to associate the subnets with the route tables
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets_cidr)
  subnet_id = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets_cidr)
  subnet_id = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_route.id
}
