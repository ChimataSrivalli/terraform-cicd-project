terraform {
  backend "s3" {
    bucket = "terraform-srivalli"

    key = "terraform.tfstate"

    region = "ap-south-1"

    encrypt = true
  }
}