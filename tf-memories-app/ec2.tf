data "aws_ami" "amazon_linux_2023_arm64" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "backend_key" {
  key_name   = "${var.project_name}-${var.environment}-key"
  public_key = file("${path.module}/../ec2-instance-keys/aws-key-pair.pub")
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.amazon_linux_2023_arm64.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.backend_key.key_name
  vpc_security_group_ids = [aws_security_group.backend_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    dnf update -y
    dnf install -y docker git

    systemctl enable docker
    systemctl start docker

    usermod -aG docker ec2-user

    mkdir -p /home/ec2-user/apps
    chown -R ec2-user:ec2-user /home/ec2-user/apps

    docker --version
    git --version
  EOF

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-backend"
  }
}

resource "aws_eip" "backend_eip" {
  instance = aws_instance.backend.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-${var.environment}-backend-eip"
  }
}