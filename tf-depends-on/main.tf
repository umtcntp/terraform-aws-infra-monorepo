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


resource "aws_s3_bucket" "my_test_bucket" {
  bucket = "my-test-bucket-terraform-2024"
  tags = {
    Name = "My test bucket"
  }
}

resource "aws_instance" "ec2_example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  tags = {
    Name = "Terraform EC2"
  }
  depends_on = [ aws_s3_bucket.my_test_bucket ]
}
