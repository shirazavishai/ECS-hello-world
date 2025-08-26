resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  tags = {
    Name = var.vpc_name
  }
  region = var.region
}

resource "aws_subnet" "private_subnet" {
  count               = length(var.private_subnet_cidrs)
  vpc_id              = aws_vpc.this.id
  cidr_block          = var.private_subnet_cidrs[count.index]
  availability_zone   = element(var.availability_zones, count.index)
  tags = {
    Name = "${var.vpc_name}-private-${count.index + 1}"
  }
}

resource "aws_subnet" "public_subnet" {
  count                     = length(var.public_subnet_cidrs)
  vpc_id                    = aws_vpc.this.id
  cidr_block                = var.public_subnet_cidrs[count.index]
  availability_zone         = element(var.availability_zones, count.index)
  map_public_ip_on_launch   = true
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.this.id
    route  { 
      cidr_block = "0.0.0.0/0"  
      gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
        Name = "${var.vpc_name}-public-rt"
    }
}

resource "aws_route_table_association" "public_rt_assoc" {
    count = length(var.public_subnet_cidrs)
    subnet_id = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id
}



# NAT Gateway + private routing
resource "aws_eip" "nat" { domain = "vpc" }   # Elastic IP for NAT Gateway
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public_subnet[0].id   # NAT Gateway in the first public subnet
    tags = {
        Name = "${var.vpc_name}-nat"
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.this.id
    route { 
      cidr_block = "0.0.0.0/0" 
      nat_gateway_id = aws_nat_gateway.nat.id 
    }
    tags = {
        Name = "${var.vpc_name}-private-rt"
    }
}

resource "aws_route_table_association" "private_rt_assoc" {
    count = length(var.private_subnet_cidrs)
    subnet_id = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.private_rt.id
}
