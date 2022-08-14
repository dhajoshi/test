# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"  
  # version = "~> 2.78"

  # VPC Basic Details
  name = "${var.prefix}"
  cidr = "10.5.0.0/16"   
  azs                 = ["us-east-1a", "us-east-1b"]
  public_subnets      = ["10.5.0.0/24", "10.5.1.0/24"]

  public_subnet_tags = {
    Name = "Public subnet"
  }
  
  igw_tags = {
    Name = "Public gateway"
  }

  tags = {
    createdBy = "infra-${var.prefix}/base"
  }

  vpc_tags = {
    Name = "${var.prefix}"
  }
}
