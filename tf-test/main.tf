provider "aws" {
  region     = "eu-central-1"
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
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  count                       = var.instance_count
  associate_public_ip_address = var.enable_public_id
  tags                        = var.project_environment
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}
#