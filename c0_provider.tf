# Setup our aws provider ( Test workflow )
variable "region" {
  default = "us-east-1"
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "news4321-terraform-infra-na"
    region = "us-east-1"
    dynamodb_table = "news4321-terraform-locks"
    key = "base/terraform.tfstate"
  }
}
