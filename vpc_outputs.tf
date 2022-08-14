# VPC Output Values

# VPC ID
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# VPC CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_subnet_a" {
  description = "List of IDs of private subnets"
  value       = module.vpc.public_subnets[0]
}

# VPC Public Subnets
output "public_subnet_b" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets[1]
}

# VPC AZs
output "azs" {
  description = "A list of availability zones spefified as argument to this module"
  value       = module.vpc.azs
}
