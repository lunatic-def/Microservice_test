################################################################################
# Security Group for ALB
################################################################################
module "alb-secgroup" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"


  name        = "alb-sg"
  description = "Security group which is used as an argument in complete-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_rules        = ["all-all"]

  tags = {
    name = "Bastion Security Group"
  }
}
################################################################################
# Route 53 DNS registration and ACM
################################################################################
# data "aws_route53_zone" "mydomain" {
#   name = "langocanh.net"
# }
# resource "aws_route53_record" "apps_dns" {
#   zone_id = data.aws_route53_zone.mydomain.zone_id
#   name    = "microservice.langocanh.net"
#   type    = "A"
#   alias {
#     name                   = module.alb.dns_name
#     zone_id                = module.alb.zone_id
#     evaluate_target_health = true
#   }
# }
################################################################################
# Application load balencer
################################################################################

# Terraform AWS Application Load Balancer (ALB)
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.5.0"

  name               = "microservices-alb"
  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets

  security_groups = [module.alb-secgroup.security_group_id]

  # For example only
  enable_deletion_protection = false

  # Listeners
  listeners = {
    # Listener-1: my-http-listener
    my-http-listener = {
      port     = 80
      protocol = "HTTP"

      # Fixed Response for Root Context 
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static message - for Root Context"
        status_code  = "200"
      }# End of Fixed Response
      rules = {
        /////////////
        home-rule = {
          actions = [{
            type = "weighted-forward"
            target_groups = [
              {
                target_group_key = "home"
                weight           = 1
              }
            ]
            stickiness = {
              enabled  = true
              duration = 3600
            }
          }]

          conditions = [{
            path_pattern = {
              values = ["/home*"]
            }
          }]
        }
      }
    } # End of my-http-listener
  }   # End of listeners block

  # Target Groups
  target_groups = {
    # Target Group-1: mytg1     
    home = {
      create_attachment                 = false #create a manual attachment
      name_prefix                       = "home-"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "ip"
      deregistration_delay              = 10
      load_balancing_cross_zone_enabled = false
      path_pattern                      = "/home*"
      protocol_version                  = "HTTP1"
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/home"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }                                        # End of health_check Block
      tags = { name = "target group for alb" } # Target Group Tags 
    }                                          # END of Target Group: mytg1

  }                                    # END OF target_groups Block
  tags = { name = "aws-ecs-nginx-lb" } # ALB Tags
}

# output "alb_dns" {
#   value = module.alb.dns_name
# }