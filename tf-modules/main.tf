provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_key_pair" "deployer" {
  key_name   = "aws-key-pair"
  public_key = file("../ec2-instance-keys/aws-key-pair.pub")
}

module "umut-webserver-1" {
  source   = "./module-1"
  key_name = aws_key_pair.deployer.key_name
}

module "umut-webserver-2" {
  source   = "./module-2"
  key_name = aws_key_pair.deployer.key_name
}