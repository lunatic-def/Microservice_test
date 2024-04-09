
################################################################################
# Standalone Task Definition (w/o Service)
################################################################################

# -> aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin id.dkr.ecr.us-east-1.amazonaws.com 
# -> build docker image an upload to repo
# -> docker build -t id.dkr.ecr.us-east-1.amazonaws.com/nginxapp1_ecr:1.0.0 .
# -> docker push id.dkr.ecr.us-east-1.amazonaws.com/nginxapp1_ecr:latest
# id.dkr.ecr.us-east-1.amazonaws.com/nginxapp1_ecr:latest


resource "aws_ecs_task_definition" "bookingapp-home" {
  depends_on               = [module.vpc]
  family                   = "bookingapp-home"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512 #0.5vCPU
  memory                   = 1024 #1Gb
  #ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn = "arn:aws:iam:::role/ecsTaskExecutionRole"


  container_definitions = jsonencode([
    {
      name      = "home"
      image     = ".dkr.ecr.us-east-1.amazonaws.com/bookingapp-home:latest"
      cpu       = 1 #0.5vCPU
      memory    = 1024 #1Gb
      essential = true
      revision  = 1
      portMappings = [
        {
          name          = "alb-access",
          containerPort = 5000,
          hostPort      = 5000,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ]
    },
    # envoy proxy
    {
      cpu       = 1 #0.5vCPU
      memory    = 1024 #1Gb
      name = "envoy"
      image = "public.ecr.aws/appmesh/aws-appmesh-envoy:v1.27.3.0-prod"
      essential = true
      environment = [
        { name = "APPMESH_VIRTUAL_NODE_NAME", value ="mesh/${aws_appmesh_mesh.bookingapp-mess.name}/virtualNode/${aws_appmesh_virtual_node.bookingapp-home.name}" }
      ]
    }
  ]) # end of environment variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      # AppPorts = 5000
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }

}

#===========================================================================================
resource "aws_ecs_task_definition" "bookingapp-movie" {
  family                   = "bookingapp-movie"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512 #0.5vCPU
  memory                   = 1024 #1Gb

  #ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn = "arn:aws:iam:::role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    #application
    {
      name      = "bookingapp-movie"
      image     = ".dkr.ecr.us-east-1.amazonaws.com/bookingapp-movie:latest"
      cpu       = 1 #0.5vCPU
      memory    = 1024 #1Gb
      essential = true
      revision  = 1
      portMappings = [
        {
          name          = "home-access",
          containerPort = 5000,
          hostPort      = 5000,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ]
    },

    # envoy proxy
    {
      cpu       = 1 #0.5vCPU
      memory    = 1024 #1Gb
      name = "envoy"
      image = "public.ecr.aws/appmesh/aws-appmesh-envoy:v1.27.3.0-prod"
      essential = true
      environment = [
        { name = "APPMESH_VIRTUAL_NODE_NAME", value ="mesh/${aws_appmesh_mesh.bookingapp-mess.name}/virtualNode/${aws_appmesh_virtual_node.bookingapp-movie.name}" }
      ]

    }
  ]) # end of environment variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      # AppPorts         = 5000
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }
}
#===========================================================================================
resource "aws_ecs_task_definition" "bookingapp-movie2" {
  family                   = "bookingapp-movie2"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512 #0.5vCPU
  memory                   = 1024 #1Gb

  #ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn = "arn:aws:iam::339712838104:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
      name      = "bookingapp-movie2"
      image     = "339712838104.dkr.ecr.us-east-1.amazonaws.com/bookingapp-movie2:latest"
      cpu       = 1 #0.5vCPU
      memory    = 1024 #1Gb
      essential = true
      revision  = 1
      portMappings = [
        {
          name          = "home-access",
          containerPort = 5000,
          hostPort      = 5000,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ]
    },
     # envoy proxy
    {
      cpu       = 1 #0.5vCPU
      memory    = 1024 #1Gb
      name = "envoy"
      image = "public.ecr.aws/appmesh/aws-appmesh-envoy:v1.27.3.0-prod"
      essential = true
      environment = [
        {name = "APPMESH_VIRTUAL_NODE_NAME", value ="mesh/${aws_appmesh_mesh.bookingapp-mess.name}/virtualNode/${aws_appmesh_virtual_node.bookingapp-movie2.name}" }
      ]

    }

  ]) # end of environment variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      # AppPorts         = 5000
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }
}
#===========================================================================================
resource "aws_ecs_task_definition" "bookingapp-redis" {
  family                   = "bookingapp-redis"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512 #0.5vCPU
  memory                   = 1024 #1Gb


  #ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume.
  execution_role_arn = "arn:aws:iam::339712838104:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    #application
    {
      name      = "bookingapp-redis"
      image     = "339712838104.dkr.ecr.us-east-1.amazonaws.com/redis_alpine3.19:latest"
      cpu       = 1 #0.5vCPU
      memory    = 1024 #1Gb
      essential = true
      revision  = 1
      portMappings = [
        {
          name          = "movie-access",
          containerPort = 6379,
          hostPort      = 6379,
          protocol      = "tcp",
          appProtocol   = "http"
        }
      ]
    },
     # envoy proxy
    {
      cpu       = 1 #0.5vCPU
      memory    = 1024 #1Gb
      name = "envoy"
      image = "public.ecr.aws/appmesh/aws-appmesh-envoy:v1.27.3.0-prod"
      essential = true
      environment = [
        { name = "APPMESH_VIRTUAL_NODE_NAME", value ="mesh/${aws_appmesh_mesh.bookingapp-mess.name}/virtualNode/${aws_appmesh_virtual_node.bookingapp-redis.name}" }
      ]

    }

  ]) # end of environment variable
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  proxy_configuration {
    type           = "APPMESH"
    container_name = "envoy"
    properties = {
      AppPorts = 6379
      IgnoredUID       = "1337"
      ProxyEgressPort  = 15001
      ProxyIngressPort = 15000
    }
  }
}
