module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  #Asset VPC Details

  name = var.name
  cidr = var.cidr

  azs = var.azs
  private_subnets = var.vpc_private_subnets
  public_subnets = var.vpc_public_subnets
  database_subnets = var.vpc_database_subnets

  #NAT Gateway 
  enable_nat_gateway = var.vpc_enable_nat_gateway 
  #single_nat_gateway = var.vpc_single_nat_gateway

  # VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    Type = "Public Subnets"
  }
  private_subnet_tags = {
    Type = "Private Subnets"
  } 
  database_subnet_tags = {
    type = "Private Database Subnets"
  }

}