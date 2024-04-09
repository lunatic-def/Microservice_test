module "bookingapp-home-sec" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"


  name        = "bookingapp-home"
  description = "Security group which is used as an argument in complete-sg"
  vpc_id = module.vpc.vpc_id

  #allow alb
  ingress_with_source_security_group_id = [
    {
       protocol                 = "tcp"
       description              = "allow alb"
       from_port                = 5000
       to_port                  = 5000
       source_security_group_id = module.alb-secgroup.security_group_id
    }
  ]
  egress_rules = ["all-all"]

    tags = {
    name = "Bookingapp-home Security Group"
  }
}
module "bookingapp-movie-sec" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"


  name        = "bookingapp-home"
  description = "Security group which is used as an argument in complete-sg"
  vpc_id = module.vpc.vpc_id

  #allow home
  ingress_with_source_security_group_id = [
    {
       protocol                 = "tcp"
       description              = "allow alb"
       from_port                = 5000
       to_port                  = 5000
       source_security_group_id = module.bookingapp-home-sec.security_group_id
    }
  ]
  egress_rules = ["all-all"]

    tags = {
    name = "Bookingapp-home Security Group"
  }
}

module "bookingapp-redis-sec" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"


  name        = "ns-sg"
  description = "Security group which is used as an argument in complete-sg"
  vpc_id = module.vpc.vpc_id

  #connect to usm and alb
 
  ingress_with_cidr_blocks = [
    {
       protocol                 = "tcp"
       description              = "allow usm for service discovery"
       from_port                = 6379
       to_port                  = 6379
       cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
  egress_rules = ["all-all"]

    tags = {
    name = "notification Security Group"
  }
}