provider "aws" {
  region     = "eu-central-1"
}


locals {
  staging_env = "staging"
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

resource "aws_vpc" "staging-vpc" {
  cidr_block = "10.5.0.0/16"
    tags = {
        Name = "${local.staging_env}-vpc-tag"
    }
}

resource "aws_subnet" "staging-subnet" {
  vpc_id            = aws_vpc.staging-vpc.id
  cidr_block        = "10.5.1.0/24"
    tags = {
        Name = "${local.staging_env}-subnet-tag"
    }
}

resource "aws_instance" "ec2_example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.staging-subnet.id

  tags = {
    Name = "${local.staging_env} - Terraform EC2 Instance"
  }
  
}