resource "aws_iam_instance_profile" "ec2_profile_prod" {
  name = "ec2_profile_prod"
  role = "stg_role"
  lifecycle {
    create_before_destroy = true # or false
  }
}

# add key
resource "aws_key_pair" "production_key" {
  key_name   = "production_key"
  public_key = file(var.PUBLIC_KEY_LOCATION)
}


# Recurso de instancia EC2
resource "aws_instance" "prod" {
  ami           = var.AMI # ID de la AMI, debes cambiarla por una válida
  instance_type = var.INSTANCE

  subnet_id              = "subnet-07551ce4ba24b4034"
  vpc_security_group_ids = ["sg-01856bcf88cb64341"]

  # Usar el perfil de instancia existente
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_prod.name

  # asociar llave
  key_name = aws_key_pair.production_key.key_name

  tags = {
    Name = "Production"
  }

  # Para asegurarte de que la instancia no elimine la VPC al hacer destroy
  lifecycle {
    ignore_changes = [
      subnet_id,
      vpc_security_group_ids,
      iam_instance_profile,
    ]
  }

}

# # # # # # # # # # # # # # # # # # # # # # # 
# Asociar la Elastic IP a la instancia EC2  #
# # # # # # # # # # # # # # # # # # # # # # # 
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.prod.id # ID de la instancia EC2
  allocation_id = var.AWS_IP_EIPALLOC  # IP estatica previamente creada
  lifecycle {
    ignore_changes = [allocation_id]
  }
}

# Variable local para almacenar la IP pública de la instancia
locals {
  instance_public_ip = aws_instance.prod.public_ip
  processed_user_data = templatefile("install.sh", {
    SSH_TERRAFORM_PUBLIC_KEY = var.SSH_TERRAFORM_PUBLIC_KEY
    DOCKER_NETWORK_NAME      = var.DOCKER_NETWORK_NAME
    URL_DISK_EFS             = var.URL_DISK_EFS
    AWS_ACCESS_KEY_ID        = var.AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY    = var.AWS_SECRET_ACCESS_KEY
    AWS_REGION               = var.AWS_REGION
    AMI                      = var.AMI
    AWS_IP_EIPALLOC          = var.AWS_IP_EIPALLOC
    AWS_ECR_REPO_ID          = var.AWS_ECR_REPO_ID
    INSTANCE                 = var.INSTANCE
    AWS_VOLUME               = var.AWS_VOLUME
    EC2_ID                   = aws_instance.prod.id
  })
}

resource "null_resource" "config_ec2" {
  # Usa una dependencia explícita en aws_instance.prod
  depends_on = [aws_instance.prod]
  connection {
    type        = "ssh"
    user        = var.AWS_SSH_USER
    host        = var.AWS_IP # aws_instance.prod.public_ip
    port        = "22"
    timeout     = "2m"
    private_key = file("~/.ssh/terraform")
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${aws_instance.prod.id} - ${var.AWS_IP}",
      "echo '${local.processed_user_data}' > /tmp/install.sh",
      "echo '${local.processed_user_data}' > /home/ubuntu/deploy.sh",
      "chmod +x /tmp/install.sh",
      # "chmod +x /home/ubuntu/deploy.sh",
      # "sudo /tmp/install.sh"
    ]

  }


  # Ejecuta comandos locales para configurar el script de usuario usando user_data
  # provisioner "local-exec" {
  #   command = templatefile("install.sh", {
  #     SSH_TERRAFORM_PUBLIC_KEY = var.SSH_TERRAFORM_PUBLIC_KEY
  #     DOCKER_NETWORK_NAME      = var.DOCKER_NETWORK_NAME
  #     URL_DISK_EFS             = var.URL_DISK_EFS
  #     AWS_ACCESS_KEY_ID        = var.AWS_ACCESS_KEY_ID
  #     AWS_SECRET_ACCESS_KEY    = var.AWS_SECRET_ACCESS_KEY
  #     AWS_REGION               = var.AWS_REGION
  #     AMI                      = var.AMI
  #     AWS_IP_EIPALLOC          = var.AWS_IP_EIPALLOC
  #     AWS_ECR_REPO_ID          = var.AWS_ECR_REPO_ID
  #     INSTANCE                 = var.INSTANCE
  #     AWS_VOLUME               = var.AWS_VOLUME
  #     EC2_ID                   = aws_instance.prod.id # Ahora seguro porque está en un recurso dependiente
  #   })
  # }
}
