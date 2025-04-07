# ────────────────────────────────────────────
# Service VPC (10.1.0.0/16)
# ────────────────────────────────────────────
resource "aws_vpc" "service_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Service-VPC"
  }
}

resource "aws_subnet" "service_private_subnet" {
  vpc_id                  = aws_vpc.service_vpc.id
  cidr_block              = "10.1.0.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Service-Private-Subnet"
  }
}

resource "aws_route_table" "service_private_rt" {
  vpc_id = aws_vpc.service_vpc.id
  tags = {
    Name = "Service-Private-RouteTable"
  }
}

resource "aws_vpn_gateway_route_propagation" "propagation" {
  vpn_gateway_id = aws_vpn_gateway.vpg.id
  route_table_id = aws_route_table.service_private_rt.id
}


resource "aws_route_table_association" "service_private_assoc" {
  subnet_id      = aws_subnet.service_private_subnet.id
  route_table_id = aws_route_table.service_private_rt.id
}
