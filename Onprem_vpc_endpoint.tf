resource "aws_security_group" "vyos_endpoint_sg" {
  name        = "vyos-endpoint-sg"
  description = "Allow HTTPS to VPC endpoints"
  vpc_id      = aws_vpc.vyos_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VyOS-Endpoint-SG"
  }
}

resource "aws_vpc_endpoint" "onprem_ssm" {
  vpc_id            = aws_vpc.vyos_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.vyos_private_subnet.id]
  security_group_ids = [aws_security_group.vyos_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "VyOS-SSM-Endpoint"
  }
}

resource "aws_vpc_endpoint" "onprem_ssmmessages" {
  vpc_id            = aws_vpc.vyos_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.vyos_private_subnet.id]
  security_group_ids = [aws_security_group.vyos_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "VyOS-SSMMessages-Endpoint"
  }
}

resource "aws_vpc_endpoint" "onprem_ec2messages" {
  vpc_id            = aws_vpc.vyos_vpc.id
  service_name      = "com.amazonaws.ap-northeast-2.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.vyos_private_subnet.id]
  security_group_ids = [aws_security_group.vyos_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "VyOS-EC2Messages-Endpoint"
  }
}