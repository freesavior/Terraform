# Bloc CIDR pour la VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block 
}

# Bloc CIDR pour le sous-réseau public
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]  
  availability_zone = var.availability_zones[count.index]  # Zone de disponibilité pour le sous-réseau public
}

# Bloc CIDR pour le sous-réseau privé
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]  
  availability_zone = var.availability_zones[count.index]  # Zone de disponibilité pour le sous-réseau privé
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"  # Routage vers Internet (0.0.0.0/0)
    nat_gateway_id =  aws_nat_gateway.main.id
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"  # Routage vers Internet (0.0.0.0/0)
    gateway_id     =  aws_internet_gateway.main.id
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private[0].id  # Choisissez un sous-réseau privé parmi les sous-réseaux créés
}


resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

