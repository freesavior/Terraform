variable "vpc_cidr_block" {
  description = "Bloc CIDR pour la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_blocks" {
  description = "Blocs CIDR pour les sous-réseaux publics"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "Blocs CIDR pour les sous-réseaux privés"
  type        = list(string)
  default     = ["10.0.16.0/24", "10.0.24.0/24"]
}

variable "availability_zones" {
  description = "Zones de disponibilité pour les sous-réseaux"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1c"]
}
