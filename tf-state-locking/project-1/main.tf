provider "aws" {
  region = "eu-central-1"
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
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "tf-state-locking-ec2"
  }
}

terraform {
  backend "s3" {
    bucket         = "umut-terraform-bucket"
    key            = "umut/terraform/remote/s3/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "dynamodb-state-locking"
  }
}
