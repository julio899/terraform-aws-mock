resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.stg_role.name
}

# Crear la instancia EC2
resource "aws_instance" "stg" {
  ami           = var.AMI
  instance_type = var.INSTANCE

  # importing EC2 Key Pair (ng-front-key): operation error EC2: ImportKeyPair, https response error StatusCode: 400
  key_name = aws_key_pair.deployer.key_name

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

      # "echo repository_url ${aws_ecr_repository.neogaleno_repo.repository_url}:latest",
      # Clonar repositorio y construir imagen Docker
      "echo $PWD",
      "ls",
      # string name - aws_ecr_repository.neogaleno_repo.id
      # numeric aws_ecr_repository.neogaleno_repo.registry_id
      "echo ${var.AWS_ECR_REPO_NAME} * ecr aws_ecr_repo_name",
      "echo ${var.AWS_ECR_REPO_ID} * ecr registry_id",
      # docker
      "docker network create -d bridge app_stg",
      "docker network ls",

      # -----------------------------
      # SYNC Last Vertions ECR images
      # -----------------------------
      "export AWS_ACCESS_KEY_ID=${var.FRONT_NG_AWS_ACCESS_KEY} && export AWS_SECRET_ACCESS_KEY=${var.FRONT_NG_AWS_SECRET_KEY} && export AWS_DEFAULT_REGION=us-east-1 && aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com",
      "aws ecr get-login-password --region ${var.AWS_REGION} | docker login --username AWS --password-stdin ${var.AWS_ECR_REPO_ID}.dkr.ecr.${var.AWS_REGION}.amazonaws.com",
      "docker pull ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/neogaleno:latest",
      "sleep 1",
      "docker pull ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/nginx:latest",


      # -----------------------------
      # FRONT -----------------------
      # "git clone https://${var.github_token}@github.com/${var.github_workspace}/${var.github_repository}.git",
      # "cd ${var.github_repository}/",
      # "git checkout staging && git pull origin staging",
      # generate .env 
      # "(echo \"ENVIROMENT=${var.FRONT_ENVIROMENT}\"; echo \"NODE_ENV=${var.FRONT_NODE_ENV}\"; echo \"MIXPANEL_KEY=${var.FRONT_MIXPANEL_KEY}\"; echo \"NG_AWS_ACCESS_KEY=${var.FRONT_NG_AWS_ACCESS_KEY}\"; echo \"NG_AWS_SECRET_KEY=${var.FRONT_NG_AWS_SECRET_KEY}\"; echo \"NG_AWS_BUCKET=${var.FRONT_NG_AWS_BUCKET}\"; echo \"NG_AWS_REGION=${var.FRONT_NG_AWS_REGION}\"; echo \"NG_AWS_S3_URL=${var.FRONT_NG_AWS_S3_URL}\"; echo \"SENTRY_DNS=${var.FRONT_SENTRY_DNS}\"; echo \"STRIPE_BILLING_URL=${var.FRONT_STRIPE_BILLING_URL}\"; echo \"VUE_APP_BACKEND_DOMAIN=${var.FRONT_VUE_APP_BACKEND_DOMAIN}\"; echo \"VUE_APP_LANDING_DOMAIN=${var.FRONT_VUE_APP_LANDING_DOMAIN}\"; echo \"CORS=${var.FRONT_CORS}\"; echo \"PORT=${var.FRONT_PORT}\"; echo \"API_VERSION=${var.FRONT_API_VERSION}\"; echo \"SERVER_CERT_SSH =${var.FRONT_SERVER_CERT_SSH}\"; echo \"DEMO_USER=${var.FRONT_DEMO_USER}\"; echo \"DEMO_USER_PASS=${var.FRONT_DEMO_USER_PASS}\"; echo \"SERVER_IP=${var.FRONT_SERVER_IP}\"; echo \"SERVER_USER=${var.FRONT_SERVER_USER}\") > .env",
      # "docker-compose -f docker-compose.yml up -d --build",
      "docker run -it --rm --net app_stg -d -p 3030 --name front-stg ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/neogaleno:latest",
      "docker network connect app_stg front-stg",
      "sleep 1",
      # <<<<<<<<< FRONT <<<<<<<<<<<
      # -----------------------------


      # PROXY -----------------------
      "sleep 1",
      "sleep 1",
      "docker run -it --link front-stg:front-stg --net app_stg -d -p 80:80 -p 443:443 --name proxy-ng ${var.AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/nginx:latest",
      "sleep 1",
      # local "docker run -it --rm --link front-stg:front-stg --net app_stg -d -p 80:80 -p 443:443 --name proxy-ng nginx",
      # Run rutine ssl
      # "docker exec -i proxy-ng nginx-generate-config-domains",
      # "sleep 1",
      "docker ps --format '{{.Names}}'",
      "echo 'Finish...'",


    ]
    connection {
      type        = "ssh"
      user        = var.AWS_SSH_USER
      private_key = tls_private_key.key.private_key_pem
      host        = self.public_ip
    }
  }
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