# Crear VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

# Crear Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "main_subnet"
  }
}

# Crear Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_igw"
  }
}

# Crear tabla de rutas y asociarla con la Subnet
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "main_route_table"
  }
}

resource "aws_route_table_association" "main_route_table_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

# Crear Security Group para SSH
resource "aws_security_group" "ssh_access" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "ssh_access"
  description = "Allow SSH access"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permitir acceso desde cualquier IP, ajusta esto según tus necesidades
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh_access"
  }
}

/*
  - https://github.com/hashicorp/terraform-provider-aws/issues/23625
  
  For those resources where we are now failing to create new resources without a configured vpc_id, 
  but use of the AWS Region's default VPC in fact occurs (and is (or was) undocumented in the API 😄),
  we will revert the changes and accept no configured vpc_id.
*/


# Crear y asignar una Elastic IP
resource "aws_eip" "elastic_ip" {
  # vpc = true
  domain   = "vpc"
  # associated with an instance
  # instance = aws_instance.web.id
  tags = {
    Name = "WebServerElasticIP"
  }
}