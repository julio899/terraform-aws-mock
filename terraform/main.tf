resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.stg_role.name
  lifecycle {
    create_before_destroy = true # or false
  }
}

# Crear la instancia EC2
resource "aws_instance" "stg" {
  ami           = var.AMI
  instance_type = var.INSTANCE

  # importing EC2 Key Pair (ng-front-key): operation error EC2: ImportKeyPair, https response error StatusCode: 400
  # key_name = aws_key_pair.deployer.key_name

  # Alternatively you could use the Terraform import command to import the pre-existing resource into your state file:
  # terraform import aws_key_pair.personal mschuchard-us-east

  tags = {
    Name = "docker-stg"
  }

  associate_public_ip_address = true

  subnet_id              = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  # DEPENDE DE ecr.tf
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # Provisión remota en la instancia EC2
  provisioner "remote-exec" {
    inline = [
      "docker -v",
      "docker-compose --version",
      "git --version",
      "aws --version",

      "echo \"export AWS_ACCESS_KEY_ID=${var.AWS_ACCESS_KEY_ID} && export AWS_SECRET_ACCESS_KEY=${var.AWS_SECRET_ACCESS_KEY} && export AWS_DEFAULT_REGION=us-east-1 && aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 202533523551.dkr.ecr.us-east-1.amazonaws.com\" >> ~/.profile",
      "source ~/.profile",
      "echo $PWD",
      "ls",
      # docker crear red para contenedores y comunicacion en los puertos
      "docker network create -d bridge app_stg",
      "docker network ls",

      # -----------------------------
      # SYNC Last Vertions ECR images
      # -----------------------------
      "aws ecr get-login-password --region ${var.AWS_REGION} | docker login --username AWS --password-stdin ${var.AWS_ECR_REPO_ID}.dkr.ecr.${var.AWS_REGION}.amazonaws.com",
      "docker pull ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/neogaleno:latest",
      # run front mientras desplega se busca la imagen de nginx
      "docker run -it --rm --net app_stg -d -p 3030 --name front-stg ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/neogaleno:latest",
      "docker pull ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/nginx:latest",

      # -----------------------------
      # FRONT -----------------------
      # "docker network connect app_stg front-stg",
      # "sleep 1",
      # <<<<<<<<< FRONT <<<<<<<<<<<
      # -----------------------------


      # PROXY -----------------------
      "docker run -it --link front-stg:front-stg --net app_stg -d -p 80:80 -p 443:443 --name proxy-ng ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/nginx:latest",
      "docker ps --format '{{.Names}}'",
    ]
    connection {
      type = "ssh"
      user = var.AWS_SSH_USER
      # oem private_key = tls_private_key.key.private_key_pem
      host    = self.public_ip
      port    = "22"
      timeout = "1m"
      # private_key = "${file("${var.key_location}")}"
      # * private_key = file("pemfile-location.pem")
      private_key = file("~/.ssh/terraform")
    }
  }
  # key_location = "~/.ssh/id_ed25519"
  # ssh -v -i <path_to_private_key/id_rsa> <USER_NAME>@<INSTANCE_IP>

}

# Guardar la clave privada en una carpeta local "keypairs"
resource "local_file" "private_key" {
  filename = "${path.module}/keypairs/${aws_instance.stg.key_name}.pem"
  content  = tls_private_key.key.private_key_pem
  # tls_private_key.ec2_key.private_key_pem
  file_permission = "0400" # Solo lectura para el propietario
}

# # # # # # # # # # # # # # # # # # # # # # # 
# Asociar la Elastic IP a la instancia EC2  #
# # # # # # # # # # # # # # # # # # # # # # # 
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.stg.id     # ID de la instancia EC2
  allocation_id = var.AWS_IP_STG_EIPALLOC # IP estatica previamente creada
  # aws_eip.elastic_ip.id # ID de la Elastic IP # in network.tf (nueva)
}

# network save state in another configuration
# data "terraform_remote_state" "network" {
#   backend = "s3"
#   config = {
#     bucket         = "ng-terraform-state"
#     key            = "network/terraform.tfstate"
#     region = "us-east-1"    
#   }
# }
