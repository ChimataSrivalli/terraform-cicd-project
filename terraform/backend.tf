terraform {
  backend "s3" {
    bucket = "srivalli-demo"

    key = "terraform.tfstate"

    region = "ap-south-1"

    encrypt = true
  }
}