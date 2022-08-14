# Create VPC Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.78.0"  
  # version = "~> 2.78"

  # VPC Basic Details
  name = "${var.prefix}"
  cidr = var.vpc_cidr_block   
  azs                 = var.vpc_availability_zones
  public_subnets      = var.vpc_public_subnets

  public_subnet_tags = {
    Name = "Public subnet"
  }
  
  igw_tags = {
    Name = "Public gateway"
  }

  tags = local.common_tags

  vpc_tags = {
    Name = "${var.prefix}"
  }
}
