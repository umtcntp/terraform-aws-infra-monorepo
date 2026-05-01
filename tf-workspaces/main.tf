provider "aws" {
  region     = "eu-central-1"
}

locals {
  instance_name = "${terraform.workspace}-instance"
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
  instance_type          = var.instance_type
  tags = {
    Name = local.instance_name
  }
}
