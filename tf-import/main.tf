provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "ec2_example" {
  ami           = "ami-051eaec1417c5d4ae"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2_example"
  }
}
