resource "aws_iam_instance_profile" "ec2_profile_prod" {
  name = "ec2_profile_prod"
  role = "stg_role"
  lifecycle {
    create_before_destroy = true # or false
  }
}

# add key
resource "aws_key_pair" "production_key" {
  key_name = "production_key"
  public_key      = file(var.PUBLIC_KEY_LOCATION)
}


# Recurso de instancia EC2
resource "aws_instance" "prod" {
  ami           = var.AMI  # ID de la AMI, debes cambiarla por una válida
  instance_type = var.INSTANCE
  
  subnet_id              = "subnet-07551ce4ba24b4034"
  vpc_security_group_ids = ["sg-01856bcf88cb64341"]

  # Usar el perfil de instancia existente
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_prod.name

  # aws_iam_instance_profile.instance_profile.name

  # asociar llave
  key_name = aws_key_pair.production_key.key_name

  tags = {
    Name = "Production"
  }

  user_data     = <<-EOF
                    #!/bin/bash
                    mkdir -p /home/ubuntu/.ssh
                    echo "${var.SSH_TERRAFORM_PUBLIC_KEY}" >> /home/ubuntu/.ssh/authorized_keys
                    echo "deploy success..." >> /home/ubuntu/ok.txt
                    sudo apt-get update -y
                    # montar disco
                    sudo apt-get install -y nfs-common
                    sudo mkdir -p /mnt/efs
                    nslookup ${var.URL_DISK_EFS}
                    sudo mount -t nfs4 -o nfsvers=4.1 ${var.URL_DISK_EFS}:/ /mnt/efs
                    # cuando se reinicie vuelva a montar el disco
                    sudo echo "${var.URL_DISK_EFS}:/ /mnt/efs nfs4 defaults,_netdev 0 0" >> /etc/fstab
                    echo "Deploy instance: ${var.AMI} IP: ${var.AWS_IP_EIPALLOC} ${var.INSTANCE} - $(date)" >> /mnt/efs/logs/deploys-prod.log
                  EOF
  
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
  allocation_id = var.AWS_IP_EIPALLOC # IP estatica previamente creada
  # aws_eip.elastic_ip.id # ID de la Elastic IP # in network.tf (nueva)
  lifecycle {
    ignore_changes = [allocation_id]
  }
}
