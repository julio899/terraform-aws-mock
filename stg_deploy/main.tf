# Definir el proveedor de AWS
provider "aws" {
  region = "us-east-1"
}

# Incluir el módulo de ECR
module "ECR" {
  source = "./ecr"
}

# Variables
variable "instance_type" {
  default = "t2.micro"
}

# Obtener el token de autorización de ECR
data "aws_ecr_authorization_token" "token" {}

# Obtener la imagen más reciente del repositorio ECR
data "aws_ecr_image" "latest" {
  repository_name = module.ecr.repository_name
  most_recent     = true
}

# Lanzar una instancia EC2 que use la imagen de Docker desde ECR
resource "aws_instance" "docker_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # AMI base de Amazon Linux 2
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  user_data = <<-EOF
    #!/bin/bash
    # Autenticarse en el repositorio ECR
    $(aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${module.ecr.repository_url})

    # Descargar la imagen más reciente
    docker pull ${module.ecr.repository_url}:${data.aws_ecr_image.latest.image_tag}

    # Ejecutar la imagen
    docker run -d -p 80:80 ${module.ecr.repository_url}:${data.aws_ecr_image.latest.image_tag}
  EOF

  tags = {
    Name = "neogaleno-instance"
  }
}

# Grupo de seguridad para la instancia EC2
resource "aws_security_group" "ec2_security_group" {
  name_prefix = "neogaleno-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "neogaleno-sg"
  }
}

# Output de la dirección pública de la instancia EC2
output "instance_public_ip" {
  value = aws_instance.docker_ec2.public_ip
}
