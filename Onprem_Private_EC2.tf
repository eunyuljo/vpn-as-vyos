resource "aws_security_group" "ssm_access" {
  name        = "EC2-SSM-SG"
  description = "Allow HTTPS for SSM endpoint"
  vpc_id      = aws_vpc.vyos_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-SSM-SG"
  }
}


resource "aws_instance" "vyos_private_ec2" {
  ami                         = data.aws_ami.amazon_linux2.id
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.vyos_private_subnet.id
  vpc_security_group_ids      = [aws_security_group.ssm_access.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name

  associate_public_ip_address = false

  tags = {
    Name = "VyOS-Private-EC2"
  }
}