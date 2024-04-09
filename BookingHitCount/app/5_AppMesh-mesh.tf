resource "aws_appmesh_mesh" "bookingapp-mess" {
  name = "bookingapp-mess"

  spec {
    egress_filter {
      type = "ALLOW_ALL"
    }
  }
}
