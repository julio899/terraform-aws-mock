
# provider "aws" {
#   region = var.FRONT_NG_AWS_REGION
# }
#  terraform import aws_instance.docker-stg i-0a2f8677d6c4d138b
resource "aws_instance" "docker-stg" {
    ami = var.AMI
    instance_type = var.INSTANCE    
}

#  terraform import aws_vpc.main_vpc vpc-032d2aeec1f5d99de
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main_vpc"
  }
}


#  terraform import aws_security_group.ssh_access sg-01856bcf88cb64341
resource "aws_security_group" "ssh_access" {
  vpc_id      = aws_vpc.main_vpc.id
  name        = "ssh_access"
  description = "Allow SSH access"

  tags = {
    Name = "ssh_access"
  }
}


# main_igw igw-07d12f47c1cd65ff5
#  terraform import aws_internet_gateway.main_igw igw-07d12f47c1cd65ff5
# vpc_id = data.aws_vpc.selected.id # aws_vpc.main_vpc.id
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_igw"
  }
}

# ID de tabla de enrutamiento * rtb-0bef8ad60aefbbefb
# subnet-07551ce4ba24b4034 us-east-1a
#  terraform import aws_route_table.main_route_table rtb-0bef8ad60aefbbefb
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


# Crear Subnet
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  tags = {
    Name = "main_subnet"
  }
}

resource "aws_route_table_association" "main_route_table_assoc" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}