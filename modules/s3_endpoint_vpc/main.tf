variable "vpc" {
  description = "Reference to the VPC module"
  
}

resource "aws_s3_bucket" "nawa969075" {
  bucket = "nawa969075"
  acl    = "private"
}





resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc.vpc_id
  service_name = "com.amazonaws.${var.aws_region}.s3"

  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id       = var.vpc.route_table_private_id
  vpc_endpoint_id      = aws_vpc_endpoint.s3.id
  depends_on           = [aws_vpc_endpoint.s3]
}
