resource "aws_appmesh_virtual_router" "movie-vrouter" {
  name      = "movie-vrouter"
  mesh_name = aws_appmesh_mesh.bookingapp-mess.id

  spec {
    listener {
      port_mapping {
        port     = 5000
        protocol = "http"
      }
    }
  }
}
#HTTP Routing
resource "aws_appmesh_route" "movie-vroute" {
  name                = "movie-vroute"
  mesh_name           = aws_appmesh_mesh.bookingapp-mess.id
  virtual_router_name = aws_appmesh_virtual_router.movie-vrouter.name

  spec {
    http_route {
      match {
        prefix = "/movie"
      }

      action {
        weighted_target {
          virtual_node = aws_appmesh_virtual_node.bookingapp-movie.name
          weight       = 30
        }

        weighted_target {
          virtual_node = aws_appmesh_virtual_node.bookingapp-movie2.name
          weight       = 70
        }
      }
    }
  }
}
