variable "vpc" {
  description = "Reference to the VPC module"
  
}


resource "aws_lb" "production" {
  name               = "alb-production"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.vpc.public_subnet_ids
}

resource "aws_security_group" "lb" {
  name        = "lb-security-group"
  description = "Security group for the load balancer"
  vpc_id      = var.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



resource "aws_lb_listener" "production_listener" {
  load_balancer_arn = aws_lb.production.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.production_tg.arn
  }
}

resource "aws_lb_target_group" "production_tg" {
  name        = "production-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc.vpc_id

  health_check {
    path = "/"
  }
}



# resource "aws_route_table_association" "private" {
#   count          = length(module.vpc.private_subnets)
#   subnet_id      = var.vpc.private_subnets[count.index]
#   route_table_id = aws_route_table.private.id
# }

# resource "aws_route_table_association" "public" {
#   count          = length(module.vpc.public_subnets)
#   subnet_id      = var.vpc.public_subnets[count.index]
#   route_table_id = aws_route_table.public.id
# }
