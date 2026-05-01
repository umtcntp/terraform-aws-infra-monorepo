provider "aws" {
  region     = "eu-central-1"
}


locals {
  ingress_rules = [
    {
      port        = 443,
      description = "Ingress rule for port 443"

    },
    {
      port        = 22,
      description = "Ingress rule for port 22"
    }
  ]
}


data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "ec2_example" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "aws-key-pair"
  vpc_security_group_ids = [aws_security_group.main.id]
}


resource "aws_security_group" "main" {
  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = ""
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
    }
  ]

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws-key-pair"
  public_key = file("../ec2-instance-keys/aws-key-pair.pub")
}
