terraform {
  backend "s3" {
    bucket       = "umut-terraform-bucket"
    key          = "memories-app/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}