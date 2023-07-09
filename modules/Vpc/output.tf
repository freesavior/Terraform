output "vpc_id" {
  description = "ID de la VPC créée"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs des sous-réseaux publics créés"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs des sous-réseaux privés créés"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID de la passerelle Internet"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "IDs de la  passerelles NAT"
  value       = aws_nat_gateway.main.id
}

output "route_table_public_id" {
  description = "ID de la table de routage publique"
  value       = aws_route_table.public.id
}
output"route_table_private_id" {
  description = "ID de la table de routage privée"
  value       = aws_route_table.private.id
}