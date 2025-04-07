
resource "aws_vpn_gateway" "vpg" {
  vpc_id = aws_vpc.service_vpc.id
  tags = {
    Name = "Service-VGW"
  }
}

# On-Premise 의 VyOS EIP를 직접적으로 참고한다.
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
