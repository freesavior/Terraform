variable "vpc" {
  description = "Reference to the VPC module"
  
}

variable"load_balancer" {
  description = "Reference to the load balancer module"
  
}

# Security group for instances in private subnets
resource "aws_security_group" "private_instances_sg" {
  name        = "private-instances-security-group"
  description = "Security group for instances in private subnets"
  vpc_id      = var.vpc.vpc_id

  # Ingress rules


  ingress {
    description      = "Allow inbound traffic from load balancer"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [var.load_balancer.security_group_id]
  }

  # Egress rules
  egress {
    description      = "Allow outbound traffic to Internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

# Security group for instances in public subnets
resource "aws_security_group" "public_instances_sg" {
  name        = "public-instances-security-group"
  description = "Security group for instances in public subnets"
  vpc_id      = var.vpc.vpc_id

  # Ingress rules
 

  ingress {
    description      = "Allow inbound traffic from load balancer"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [var.load_balancer.security_group_id]
  }

  # Egress rules
  egress {
    description      = "Allow outbound traffic to Internet"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_launch_template" "preproduction" {
  name                    = "preproduction-launch-template"
  image_id                = var.image_id  # ID de l'image AMI souhaitée
  instance_type           = var.instance_type      # Type d'instance souhaité
  #security_group_names    = [aws_security_group.private_instances_sg.id]
  #key_name                = var.key_name   # Nom de la paire de clés SSH

  monitoring {
    enabled               = true
  }
  tags = {
    Name                  = "preproduction"
    Environment           = "preproduction"
  }
}

resource "aws_launch_template" "production" {
  name                    = "production-launch-template"
  image_id                = var.image_id  # ID de l'image AMI souhaitée
  instance_type           = var.instance_type      # Type d'instance souhaité
  #security_group_names    = [aws_security_group.private_instances_sg.id]
  #key_name                = var.key_name   # Nom de la paire de clés SSH
  monitoring {
    enabled               = true
  }
  tags = {
    Name                  = "production"
    Environment           = "production"
  }
}

resource "aws_launch_template" "dev" {
  name                    = "dev-launch-template"
  image_id                = var.image_id  # ID de l'image AMI souhaitée
  instance_type           = var.instance_type      # Type d'instance souhaité
  #security_group_names    = [aws_security_group.public_instances_sg.id]
  #key_name                = var.key_name   # Nom de la paire de clés SSH
  monitoring {
    enabled               = true
  }
  tags = {
    Name                  = "dev"
    Environment           = "dev"
  }
}

resource "aws_launch_template" "test" {
  name                    = "test-launch-template"
  image_id                = var.image_id  # ID de l'image AMI souhaitée
  instance_type           = var.instance_type      # Type d'instance souhaité
  #security_group_names    = [aws_security_group.public_instances_sg.id]
  #key_name                = var.key_name   # Nom de la paire de clés SSH
  monitoring {
    enabled               = true
  }
  tags = {
    Name                  = "test"
    Environment           = "test"
  }
}


resource "aws_autoscaling_group" "preproduction" {
  name                 = "preproduction-autoscaling-group"
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  health_check_grace_period = 300
  vpc_zone_identifier  = var.vpc.private_subnet_ids

  launch_template {
    id      = aws_launch_template.preproduction.id
    version = "$Latest"
  }

  
}

resource "aws_autoscaling_group" "production" {
  name                 = "production-autoscaling-group"
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  health_check_grace_period = 300
  vpc_zone_identifier  = var.vpc.private_subnet_ids

  launch_template {
    id      = aws_launch_template.production.id
    version = "$Latest"
  }

  
}

resource "aws_autoscaling_group" "dev" {
  name                 = "dev-autoscaling-group"
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  health_check_grace_period = 300
  vpc_zone_identifier  = var.vpc.public_subnet_ids

  launch_template {
    id      = aws_launch_template.dev.id
    version = "$Latest"
  }

  
}

resource "aws_autoscaling_group" "test" {
  name                 = "test-autoscaling-group"
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2
  health_check_grace_period = 300
  vpc_zone_identifier  = var.vpc.public_subnet_ids

  launch_template {
    id      = aws_launch_template.test.id
    version = "$Latest"
  }

 
}
