# ────────────────────────────────────────────
# Security Group for SSM Endpoints
# ────────────────────────────────────────────
resource "aws_security_group" "service_endpoint_sg" {
  name        = "service-endpoint-sg"
  description = "Allow HTTPS from Service VPC"
  vpc_id      = aws_vpc.service_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"] # Service VPC 내부에서만 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Service-SSM-Endpoint-SG"
  }
}

# ────────────────────────────────────────────
# Interface VPC Endpoints for Session Manager
# ────────────────────────────────────────────
resource "aws_vpc_endpoint" "aws_ssm" {
  vpc_id             = aws_vpc.service_vpc.id
  service_name       = "com.amazonaws.ap-northeast-2.ssm"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.service_private_subnet.id]
  security_group_ids = [aws_security_group.service_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "Service-SSM-Endpoint"
  }
}

resource "aws_vpc_endpoint" "aws_ssmmessages" {
  vpc_id             = aws_vpc.service_vpc.id
  service_name       = "com.amazonaws.ap-northeast-2.ssmmessages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.service_private_subnet.id]
  security_group_ids = [aws_security_group.service_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "Service-SSMMessages-Endpoint"
  }
}

resource "aws_vpc_endpoint" "aws_ec2messages" {
  vpc_id             = aws_vpc.service_vpc.id
  service_name       = "com.amazonaws.ap-northeast-2.ec2messages"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.service_private_subnet.id]
  security_group_ids = [aws_security_group.service_endpoint_sg.id]
  private_dns_enabled = true

  tags = {
    Name = "Service-EC2Messages-Endpoint"
  }
}
