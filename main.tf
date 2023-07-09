provider "aws" {
  region = var.region
}

# Declare the VPC module
module "vpc" {
  source      = "./modules/vpc"
#   vpc_name    = "Production"

}



# Declare the load balancer module
module "load_balancer" {
  source    = "./modules/load_balancer"
  vpc = module.vpc
  

}

# Declare the auto scaling group module
module "auto_scaling" {
  source = "./modules/auto_scaling"
  vpc = module.vpc
  load_balancer = module.load_balancer
}




# Declare the S3 bucket module
module "s3_bucket" {
  source = "./modules/s3_bucket"
  vpc = module.vpc

}



