module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.10.0"
  cluster_name = "bookingapp-cluster"

  # Capacity provider
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
        base   = 20
      }
    }
  }
  # #cloudwatch ...
  #  cluster_configuration = {
  #   execute_command_configuration = {
  #     logging = "OVERRIDE"
  #     log_configuration = {
  #       cloud_watch_log_group_name = "/aws/ecs/aws-fargate"
  #     }
  #   }
  # }

    tags = { name = "ecs-fargate-cluster" }
} 
