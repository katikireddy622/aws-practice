# create the VPC
resource "aws_vpc" "rahkat_vpc" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = var.vpcName
  }
} # end resource

# create the public Subnet
resource "aws_subnet" "rahkat_vpc_public_Subnet" {
  vpc_id                  = aws_vpc.rahkat_vpc.id
  cidr_block              = var.subnetCIDRblock_public
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone
  tags = {
    Name = "${var.vpcName} public Subnet"
  }
} # end resource

# create the private Subnet
resource "aws_subnet" "rahkat_vpc_private_Subnet" {
  vpc_id            = aws_vpc.rahkat_vpc.id
  cidr_block        = var.subnetCIDRblock_private
  availability_zone = var.availabilityZone
  tags = {
    Name = "${var.vpcName} private Subnet"
  }
} # end resource

# create VPC Network access control list
resource "aws_network_acl" "rahkat_vpc_Security_ACL" {
  vpc_id     = aws_vpc.rahkat_vpc.id
  subnet_ids = [aws_subnet.rahkat_vpc_public_Subnet.id, aws_subnet.rahkat_vpc_private_Subnet.id]
  # allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22
    to_port    = 22
  }

  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80
    to_port    = 80
  }

  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }

  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22
    to_port    = 22
  }

  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80
    to_port    = 80
  }

  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name = "${var.vpcName} ACL"
  }
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "rahkat_vpc_GW" {
  vpc_id = aws_vpc.rahkat_vpc.id
  tags = {
    Name = "${var.vpcName} Internet Gateway"
  }
} # end resource
# Create the Route Table
resource "aws_route_table" "rahkat_vpc_route_table_igw" {
  vpc_id = aws_vpc.rahkat_vpc.id
  tags = {
    Name = "${var.vpcName} Route Table for IGW"
  }
} # end resource
# Create the Internet Access
resource "aws_route" "rahkat_vpc_internet_access" {
  route_table_id         = aws_route_table.rahkat_vpc_route_table_igw.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.rahkat_vpc_GW.id
} # end resource
# Associate the Route Table with the Subnet
resource "aws_route_table_association" "rahkat_vpc_association_igw" {
  subnet_id      = aws_subnet.rahkat_vpc_public_Subnet.id
  route_table_id = aws_route_table.rahkat_vpc_route_table_igw.id
} # end resource
# end vpc.tf

# NAT Gateway stuff
resource "aws_eip" "nat_gateway_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.rahkat_vpc_public_Subnet.id
  tags = {
    "Name" = "NatGateway in public subnet for ${var.vpcName}"
  }
}

resource "aws_route_table" "rahkat_vpc_route_table_nat" {
  vpc_id = aws_vpc.rahkat_vpc.id
  tags = {
    Name = "${var.vpcName} Route Table for NAT"
  }
}

resource "aws_route" "rahkat_vpc_private_access" {
  route_table_id         = aws_route_table.rahkat_vpc_route_table_nat.id
  destination_cidr_block = var.destinationCIDRblock
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}

resource "aws_route_table_association" "rahkat_vpc_association_nat" {
  subnet_id      = aws_subnet.rahkat_vpc_private_Subnet.id
  route_table_id = aws_route_table.rahkat_vpc_route_table_nat.id
}

