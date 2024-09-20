# Crear la instancia EC2
resource "aws_instance" "stg" {
  ami                    = var.ami
  instance_type          = var.instance

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

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  // aws_ecr_repository.neogaleno_repo.
  # Provisión remota en la instancia EC2
 provisioner "remote-exec" {
  inline = [
      "sudo snap install aws-cli --channel=v1/stable --classic",
      "uname -a",
      "docker -v",
      "docker-compose --version",
      "git --version",
      "aws --version",
      "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.neogaleno_repo.registry_id}.dkr.ecr.${var.aws_region}.amazonaws.com",
      # Clonar repositorio y construir imagen Docker
      "echo $PWD",
      "ls",
      "echo ${aws_ecr_repository.neogaleno_repo.id} * ecr id",
      "echo ${aws_ecr_repository.neogaleno_repo.registry_id} * ecr registry_id",
      
      
      # -----------------------------
      # FRONT -----------------------
      "git clone https://${var.github_token}@github.com/${var.github_workspace}/${var.github_repository}.git",
      "cd ${var.github_repository}/",     
      "cat README.md",     
      "git checkout staging && git pull origin staging",
      # generate .env 
      "(echo \"ENVIROMENT=${var.FRONT_ENVIROMENT}\"; echo \"NODE_ENV=${var.FRONT_NODE_ENV}\"; echo \"MIXPANEL_KEY=${var.FRONT_MIXPANEL_KEY}\"; echo \"NG_AWS_ACCESS_KEY=${var.FRONT_NG_AWS_ACCESS_KEY}\"; echo \"NG_AWS_SECRET_KEY=${var.FRONT_NG_AWS_SECRET_KEY}\"; echo \"NG_AWS_BUCKET=${var.FRONT_NG_AWS_BUCKET}\"; echo \"NG_AWS_REGION=${var.FRONT_NG_AWS_REGION}\"; echo \"NG_AWS_S3_URL=${var.FRONT_NG_AWS_S3_URL}\"; echo \"SENTRY_DNS=${var.FRONT_SENTRY_DNS}\"; echo \"STRIPE_BILLING_URL=${var.FRONT_STRIPE_BILLING_URL}\"; echo \"VUE_APP_BACKEND_DOMAIN=${var.FRONT_VUE_APP_BACKEND_DOMAIN}\"; echo \"VUE_APP_LANDING_DOMAIN=${var.FRONT_VUE_APP_LANDING_DOMAIN}\"; echo \"CORS=${var.FRONT_CORS}\"; echo \"PORT=${var.FRONT_PORT}\"; echo \"API_VERSION=${var.FRONT_API_VERSION}\"; echo \"SERVER_CERT_SSH =${var.FRONT_SERVER_CERT_SSH }\"; echo \"DEMO_USER=${var.FRONT_DEMO_USER}\"; echo \"DEMO_USER_PASS=${var.FRONT_DEMO_USER_PASS}\"; echo \"SERVER_IP=${var.FRONT_SERVER_IP}\"; echo \"SERVER_USER=${var.FRONT_SERVER_USER}\") > .env",
      "sleep 1",
      "docker-compose -f docker-compose.yml up -d --build",
      # <<<<<<<<< FRONT <<<<<<<<<<<
      # -----------------------------


      
      # PROXY -----------------------
      "docker run -it --rm -d -p 80:80 -p 443:443 --name proxy-ng nginx",      
      # "docker pull ${aws_ecr_repository.neogaleno_repo.repository_url}:latest",
      # "docker run hello-world",
      # "docker tag hello-world:latest ${aws_ecr_repository.neogaleno_repo.repository_url}",
      # "docker push ${aws_ecr_repository.neogaleno_repo.repository_url}:latest",
      "sleep 3",
      "echo 'Finish...'",

      // "aws ecr get-login-password --region ${var.aws_region} | sudo docker login --username AWS --password-stdin ${coalesce(data.aws_ecr_repository.neogaleno.repository_url, aws_ecr_repository.neogaleno_repo[count.index].repository_url)}:latest",
      // "$(aws ecr get-login-password --region ${var.aws_region} | sudo docker login --username AWS --password-stdin ${aws_ecr_repository.my_repo.repository_url})",
      // "sudo docker build -t my-docker-repo .",
      // "sudo docker tag my-docker-repo:latest ${aws_ecr_repository.my_repo.repository_url}:latest",
      // "sudo docker push ${aws_ecr_repository.my_repo.repository_url}:latest"
    ]
    connection {
      type        = "ssh"
      user        = var.aws_ssh_user
      private_key = tls_private_key.key.private_key_pem
      host        = self.public_ip
    }
  }
}

# # # # # # # # # # # # # # # # # # # # # # # 
# Asociar la Elastic IP a la instancia EC2  #
# # # # # # # # # # # # # # # # # # # # # # # 
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.stg.id    # ID de la instancia EC2
  allocation_id = aws_eip.elastic_ip.id  # ID de la Elastic IP
}