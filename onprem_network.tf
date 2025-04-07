

# ────────────────────────────────────────────
# VyOS VPC (10.0.0.0/16)
# ────────────────────────────────────────────
resource "aws_vpc" "vyos_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VyOS-VPC"
  }
}

resource "aws_subnet" "vyos_subnet" {
  vpc_id                  = aws_vpc.vyos_vpc.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-2a"
  tags = {
    Name = "VyOS-Subnet"
  }
}

resource "aws_internet_gateway" "vyos_igw" {
  vpc_id = aws_vpc.vyos_vpc.id
  tags = {
    Name = "VyOS-IGW"
  }
}

resource "aws_route_table" "vyos_rt" {
  vpc_id = aws_vpc.vyos_vpc.id
  tags = {
    Name = "VyOS-RouteTable"
  }
}

resource "aws_route" "vyos_default_route" {
  route_table_id         = aws_route_table.vyos_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vyos_igw.id
}

resource "aws_route_table_association" "vyos_assoc" {
  subnet_id      = aws_subnet.vyos_subnet.id
  route_table_id = aws_route_table.vyos_rt.id
}

