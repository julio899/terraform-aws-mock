# provider "aws" {
#   region = "us-east-1"  # Cambia esto por la región en la que deseas desplegar la instancia
# }

# # Crear un par de claves para acceso SSH
# resource "aws_key_pair" "example" {
#   key_name   = "my-key"  # Cambia el nombre según tus necesidades
#   public_key = file("~/.ssh/id_rsa.pub")  # Asegúrate de tener la clave pública generada en tu máquina
# }

# # Obtener el ID de la VPC predeterminada
# data "aws_vpc" "default" {
#   default = true
# }

# # Obtener una subred de la VPC predeterminada
# data "aws_subnet_ids" "default" {
#   vpc_id = data.aws_vpc.default.id
# }

# # Crear una instancia EC2 t2.micro
# resource "aws_instance" "example" {
#   ami             = "ami-08c40ec9ead489470"  # Amazon Linux 2 AMI, cambia según la región o AMI que prefieras
#   instance_type   = "t2.micro"
#   key_name        = aws_key_pair.example.key_name
#   subnet_id       = data.aws_subnet_ids.default.ids[0]

#   tags = {
#     Name = "My-T2-Micro-Instance"
#   }

#   # Bloques opcionales para configuración
#   root_block_device {
#     volume_size = 8  # Tamaño del disco en GB
#   }

#   # Definir el tipo de conexión y seguridad
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id]

#   # Agregar una dirección IP pública
#   associate_public_ip_address = true
# }

# # Crear un grupo de seguridad para permitir acceso SSH
# resource "aws_security_group" "allow_ssh" {
#   vpc_id = data.aws_vpc.default.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # Cambia esto a una IP específica para mayor seguridad
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "allow_ssh"
#   }
# }


# Crear la instancia EC2
resource "aws_instance" "builder1" {
  ami                    = "ami-0d908d8876d2dafbd"
  instance_type          = var.instance
  # ami-0f0417a092a64beee
  # subnet_id              = aws_subnet.main_subnet.id
  # vpc_security_group_ids = [aws_security_group.ssh_access.id]
  # associate_public_ip_address = true
  # key_name = aws_key_pair.deployer.key_name

  # iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  #tags = {
  #  Name = "docker-builder"
  #}

/*  
  # Provisión remota en la instancia EC2
 provisioner "remote-exec" {
  inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo yum install git -y",
      "sudo service docker start",
      // "$(aws ecr get-login-password --region us-east-1 | sudo docker login --username AWS --password-stdin ${aws_ecr_repository.my_repo.repository_url})",
      // "git clone https://${var.github_user}:${var.github_token}@github.com/${var.GITHUB_WORKSPACE}/${var.GITHUB_REPOSITORY} && cd ${var.GITHUB_REPOSITORY}/",
      // "sudo docker build -t my-docker-repo .",
      // "sudo docker tag my-docker-repo:latest ${aws_ecr_repository.my_repo.repository_url}:latest",
      // "sudo docker push ${aws_ecr_repository.my_repo.repository_url}:latest"
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = tls_private_key.key.private_key_pem
      host        = self.public_ip
    }
  }
   */
}