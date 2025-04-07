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

resource "aws_subnet" "service_subnet" {
  vpc_id                  = aws_vpc.service_vpc.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false
  tags = {
    Name = "Service-Subnet"
  }
}

resource "aws_vpn_gateway" "vpg" {
  vpc_id = aws_vpc.service_vpc.id
  tags = {
    Name = "Service-VGW"
  }
}

resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = aws_eip.vyos_eip.public_ip
  type       = "ipsec.1"
  tags = {
    Name = "VyOS-CGW"
  }
}

resource "aws_vpn_connection" "vpn" {
  vpn_gateway_id      = aws_vpn_gateway.vpg.id
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  static_routes_only  = false
  tags = {
    Name = "VyOS-VPN"
  }
}

resource "aws_route_table" "service_rt" {
  vpc_id = aws_vpc.service_vpc.id
  tags = {
    Name = "Service-RouteTable"
  }
}

resource "aws_vpn_gateway_route_propagation" "propagation" {
  vpn_gateway_id = aws_vpn_gateway.vpg.id
  route_table_id = aws_route_table.service_rt.id
}

resource "aws_route_table_association" "service_assoc" {
  subnet_id      = aws_subnet.service_subnet.id
  route_table_id = aws_route_table.service_rt.id
}
