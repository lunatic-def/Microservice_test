##############################
## HOME
##############################
resource "aws_appmesh_virtual_node" "bookingapp-home" {
  name      = "home-vnode"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    backend {
      virtual_service {
        virtual_service_name = "movie.internal-bookingapp.com"
      }
    }

    listener {
      port_mapping {
        port     = 5000
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = "home"
        namespace_name = aws_service_discovery_private_dns_namespace.local_sd_dns.name
      }
    }
  }
}
##############################
## Movie
##############################
resource "aws_appmesh_virtual_node" "bookingapp-movie" {
  name      = "movie-vnode"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    backend {
      virtual_service {
        virtual_service_name = "redis.internal-bookingapp.com"
      }
    }

    listener {
      port_mapping {
        port     = 5000
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = "movie"
        namespace_name = aws_service_discovery_private_dns_namespace.local_sd_dns.name
      }
    }
  }
}
output "appmesh_vnode_movie_arn" {
  value = aws_appmesh_virtual_node.bookingapp-movie.arn
}
##############################
## Movie 2
##############################
resource "aws_appmesh_virtual_node" "bookingapp-movie2" {
  name      = "movie2-vnode"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    backend {
      virtual_service {
        virtual_service_name = "redis.internal-bookingapp.com"
      }
    }

    listener {
      port_mapping {
        port     = 5000
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {

        service_name   = "movie2"
        namespace_name = aws_service_discovery_private_dns_namespace.local_sd_dns.name
      }
    }
  }
}
output "appmesh_vnode_movie2_arn" {
  value = aws_appmesh_virtual_node.bookingapp-movie2.arn
}
##############################
## Redis
##############################
resource "aws_appmesh_virtual_node" "bookingapp-redis" {
  name      = "redis-vnode"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    listener {
      port_mapping {
        port     = 6379
        protocol = "http"
      }
    }

    service_discovery {
      aws_cloud_map {
        service_name   = "redis"
        namespace_name = aws_service_discovery_private_dns_namespace.local_sd_dns.name
      }
    }
  }
}
output "appmesh_vnode_redis_arn" {
  value = aws_appmesh_virtual_node.bookingapp-redis.arn
}
