################################
## HOME
################################
resource "aws_appmesh_virtual_service" "home" {
  name      = "home.internal-bookingapp.com"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.bookingapp-home.name
      }
    }
  }
}

################################
## MOVIE
################################
resource "aws_appmesh_virtual_service" "movie" {
  name      = "movie.internal-bookingapp.com"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    provider {
      virtual_router {
        virtual_router_name = aws_appmesh_virtual_router.movie-vrouter.name
      }
    }
  }
}
################################
## MOVIE 2
################################
# resource "aws_appmesh_virtual_service" "movie2" {
#   name      = "movie2.internal-bookingapp.com"
#   mesh_name = aws_appmesh_mesh.bookingapp-mess.id

#   spec {
#     provider {
#       virtual_node {
#         virtual_node_name = aws_appmesh_virtual_node.bookingapp-movie2.name
#       }
#     }
#   }
# }
################################
## REDIS
################################
resource "aws_appmesh_virtual_service" "redis" {
  name      = "redis.internal-bookingapp.com"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    provider {
      virtual_node {
        virtual_node_name = aws_appmesh_virtual_node.bookingapp-redis.name
      }
    }
  }
}



# router to movie service (1& 2)
