################################################################################
# Booking app home service
################################################################################
module "bookingapp-home" {
  source     = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "bookingapp-home"
  cluster_arn = module.ecs_cluster.arn
  subnet_ids  = module.vpc.private_subnets
  #launch_type = "FARGATE"

  cpu    = 1024
  memory = 1024
  service_registries = {
    registry_arn = aws_service_discovery_service.bookingapp-home.arn
  }

  # Enables ECS Exec
  enable_execute_command = false
  #rolling update
  #force_new_deployment = true 
  # Disable creation of the task execution IAM role; `task_exec_iam_role_arn` should be provided
  create_task_exec_iam_role = false
  # Disable creation of the task execution IAM role policy
  create_task_exec_policy = false
  # Disable creation of the tasks IAM role; `tasks_iam_role_arn` should be provided
  create_tasks_iam_role = false
  # Disable creation of the service security group
  create_security_group = false
  #Tasks definition 
  create_task_definition = false
  task_definition_arn    = aws_ecs_task_definition.bookingapp-home.arn

  /////////////////////
  #Number of tasks
  desired_count    = 1
  assign_public_ip = false

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 147 #!!importance


  ///////////////////////////////////////
  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["home"].arn
      container_name   = "home"
      family           = "home"
      container_port   = 5000
    }
  }
  security_group_ids = [module.bookingapp-home-sec.security_group_id]
  # Auto-Scaling
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 2
  # 3 type for targettracking -> ECSServiceAverageCPUltilization, ECSServiceAverageMemoryUltilization, ALBRequestCountPerTarget
  # autoscaling_policies = {
  #   "alb_request": {
  #     "policy_type": "TargetTrackingScaling",
  #     "target_tracking_scaling_policy_configuration": {
  #       "predefined_metric_specification": {
  #         "predefined_metric_type": "ALBRequestCountPerTarget"
  #         "resource_label": "app/aws-ecs-nginx-lb/7cd247c58579b02f/targetgroup/mytg1-20240329023828376900000006/b1a7b0e68c1fb03e"
  #       }

  #     "target_value": 1000
  #     "cooldown": 60
  #     }
  #   }
  # }
  service_tags = {
    "ServiceTag" = "Tag on service level"
  }
  tags = { name = "ecs_service" }
}

################################################################################
# Booking app movie service
################################################################################
module "bookingapp-movie" {
  source     = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "bookingapp-movie"
  cluster_arn = module.ecs_cluster.arn
  subnet_ids  = module.vpc.private_subnets
  #launch_type = "FARGATE"

  cpu    = 1024
  memory = 1024

  service_registries = {
    registry_arn = aws_service_discovery_service.bookingapp-movie.arn
  }

  # Enables ECS Exec
  enable_execute_command = false
  #rolling update
  #force_new_deployment = true 
  # Disable creation of the task execution IAM role; `task_exec_iam_role_arn` should be provided
  create_task_exec_iam_role = false
  # Disable creation of the task execution IAM role policy
  create_task_exec_policy = false
  # Disable creation of the tasks IAM role; `tasks_iam_role_arn` should be provided
  create_tasks_iam_role = false
  # Disable creation of the service security group
  create_security_group = false
  #Tasks definition 
  create_task_definition = false
  task_definition_arn    = aws_ecs_task_definition.bookingapp-movie.arn

  /////////////////////
  #Number of tasks
  desired_count    = 1
  assign_public_ip = false

  security_group_ids = [module.bookingapp-movie-sec.security_group_id]
  # Auto-Scaling
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 2
  # 3 type for targettracking -> ECSServiceAverageCPUltilization, ECSServiceAverageMemoryUltilization, ALBRequestCountPerTarget
  # autoscaling_policies = {
  #   "alb_request": {
  #     "policy_type": "TargetTrackingScaling",
  #     "target_tracking_scaling_policy_configuration": {
  #       "predefined_metric_specification": {
  #         "predefined_metric_type": "ALBRequestCountPerTarget"
  #         "resource_label": "app/aws-ecs-nginx-lb/7cd247c58579b02f/targetgroup/mytg1-20240329023828376900000006/b1a7b0e68c1fb03e"
  #       }

  #     "target_value": 1000
  #     "cooldown": 60
  #     }
  #   }
  # }
  service_tags = {
    "ServiceTag" = "Tag on service level"
  }
  tags = { name = "ecs_service" }
}
################################################################################
# Booking app redis service
################################################################################
module "bookingapp-redis" {
  source     = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "bookingapp-redis"
  cluster_arn = module.ecs_cluster.arn
  subnet_ids  = module.vpc.private_subnets
  #   launch_type = "FARGATE"

  cpu    = 1024
  memory = 1024

  # Service discovery - microservice.local
  # service_connect_configuration  = {
  #   namespace_id = aws_service_discovery_private_dns_namespace.local_sd_dns.id
  #   #service = "${aws_service_discovery_service.notification_service}"
  #   enabled = true
  # }

  service_registries = {
    registry_arn = aws_service_discovery_service.bookingapp-redis.arn
  }


  # Enables ECS Exec
  enable_execute_command = false
  #rolling update
  #force_new_deployment = true 
  # Disable creation of the task execution IAM role; `task_exec_iam_role_arn` should be provided
  create_task_exec_iam_role = false
  # Disable creation of the task execution IAM role policy
  create_task_exec_policy = false
  # Disable creation of the tasks IAM role; `tasks_iam_role_arn` should be provided
  create_tasks_iam_role = false
  # Disable creation of the service security group
  create_security_group = false
  #Tasks definition 
  create_task_definition = false
  task_definition_arn    = aws_ecs_task_definition.bookingapp-redis.arn

  /////////////////////
  #Number of tasks
  desired_count    = 1
  assign_public_ip = false

  security_group_ids = [module.bookingapp-redis-sec.security_group_id]
  # Auto-Scaling
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 2
  # 3 type for targettracking -> ECSServiceAverageCPUltilization, ECSServiceAverageMemoryUltilization, ALBRequestCountPerTarget
  # autoscaling_policies = {
  #   "alb_request": {
  #     "policy_type": "TargetTrackingScaling",
  #     "target_tracking_scaling_policy_configuration": {
  #       "predefined_metric_specification": {
  #         "predefined_metric_type": "ALBRequestCountPerTarget"
  #         "resource_label": "app/aws-ecs-nginx-lb/7cd247c58579b02f/targetgroup/mytg1-20240329023828376900000006/b1a7b0e68c1fb03e"
  #       }

  #     "target_value": 1000
  #     "cooldown": 60
  #     }
  #   }
  # }
  service_tags = {
    "ServiceTag" = "Tag on service level"
  }
  tags = { name = "ecs_service" }
}
################################################################################
# Booking app movie service 2
################################################################################
module "bookingapp-movie2" {
  source     = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "bookingapp-movie2"
  cluster_arn = module.ecs_cluster.arn
  subnet_ids  = module.vpc.private_subnets
  #launch_type = "FARGATE"

  cpu    = 1024
  memory = 1024

  service_registries = {
    registry_arn = aws_service_discovery_service.bookingapp-movie2.arn
  }

  # Enables ECS Exec
  enable_execute_command = false
  #rolling update
  #force_new_deployment = true 
  # Disable creation of the task execution IAM role; `task_exec_iam_role_arn` should be provided
  create_task_exec_iam_role = false
  # Disable creation of the task execution IAM role policy
  create_task_exec_policy = false
  # Disable creation of the tasks IAM role; `tasks_iam_role_arn` should be provided
  create_tasks_iam_role = false
  # Disable creation of the service security group
  create_security_group = false
  #Tasks definition 
  create_task_definition = false
  task_definition_arn    = aws_ecs_task_definition.bookingapp-movie2.arn

  /////////////////////
  #Number of tasks
  desired_count    = 1
  assign_public_ip = false

  security_group_ids = [module.bookingapp-movie-sec.security_group_id]
  # Auto-Scaling
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 2
  # 3 type for targettracking -> ECSServiceAverageCPUltilization, ECSServiceAverageMemoryUltilization, ALBRequestCountPerTarget
  # autoscaling_policies = {
  #   "alb_request": {
  #     "policy_type": "TargetTrackingScaling",
  #     "target_tracking_scaling_policy_configuration": {
  #       "predefined_metric_specification": {
  #         "predefined_metric_type": "ALBRequestCountPerTarget"
  #         "resource_label": "app/aws-ecs-nginx-lb/7cd247c58579b02f/targetgroup/mytg1-20240329023828376900000006/b1a7b0e68c1fb03e"
  #       }

  #     "target_value": 1000
  #     "cooldown": 60
  #     }
  #   }
  # }
  service_tags = {
    "ServiceTag" = "Tag on service level"
  }
  tags = { name = "ecs_service" }
}
