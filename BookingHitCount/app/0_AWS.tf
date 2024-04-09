#define terraform version
terraform {
  required_version = ">= 1.6" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    } 
  }
}

# Provider AWS
provider "aws" {
  region  = var.aws_region
  profile = "default"
  access_key = var.access_key
  secret_key = var.secret-key
}
provider "docker" {
  #host = "unix:///var/run/docker.sock"
  #docker context ls
  host = "npipe:////./pipe/docker_engine"
  #host = "npipe:////.//pipe//docker_engine"
}
