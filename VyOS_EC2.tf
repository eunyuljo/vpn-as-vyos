# ────────────────────────────────────────────
# IAM Role for SSM
# ────────────────────────────────────────────
resource "aws_iam_role" "vyos_ssm_role" {
  name = "VyOS-SSM-Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_core_attach" {
  role       = aws_iam_role.vyos_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "vyos_instance_profile" {
  name = "VyOS-SSM-Instance-Profile"
  role = aws_iam_role.vyos_ssm_role.name
}


resource "aws_security_group" "vyos_sg" {
  vpc_id = aws_vpc.vyos_vpc.id
  name   = "VyOS-SG"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 500
    to_port     = 500
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "VyOSSecurityGroup"
  }
}


# EIP 연결 (이제 interface_id는 고정됨)
resource "aws_eip" "vyos_eip" {
  network_interface = aws_network_interface.vyos_eni.id
  depends_on        = [aws_internet_gateway.vyos_igw]

  tags = {
    Name = "VyOS-Router"
  }
}


# ENI 생성
resource "aws_network_interface" "vyos_eni" {
  subnet_id         = aws_subnet.vyos_subnet.id
  security_groups   = [aws_security_group.vyos_sg.id]
  source_dest_check = false

  tags = {
    Name = "VyOS-ENI"
  }
}


# EC2 인스턴스에 ENI를 연결
resource "aws_instance" "vyos" {
  ami                         = "ami-02f26353a98d466a5"
  instance_type               = "t3.medium"
  key_name                    = "fnf-test"
  iam_instance_profile        = aws_iam_instance_profile.vyos_instance_profile.name
  

  network_interface {
    network_interface_id = aws_network_interface.vyos_eni.id
    device_index         = 0
  }

  tags = {
    Name = "VyOS-Router"
  }
}