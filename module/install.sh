#!/bin/bash

# Actualizar e instalar dependencias
sudo apt update -y
sudo apt install nfs-common -y
# Montar EFS
sudo mkdir -p /mnt/efs
# sudo nslookup fs-074a9374f12b6ec00.efs.us-east-1.amazonaws.com
sudo nslookup ${URL_DISK_EFS}
# sudo mount -t nfs4 -o nfsvers=4.1 fs-074a9374f12b6ec00.efs.us-east-1.amazonaws.com:/ /mnt/efs
sudo mount -t nfs4 -o nfsvers=4.1 ${URL_DISK_EFS}:/ /mnt/efs

echo "${URL_DISK_EFS}:/ /mnt/efs nfs4 defaults,_netdev 0 0" | sudo tee -a /etc/fstab

# Crear directorio .ssh y agregar clave pública
mkdir -p /home/ubuntu/.ssh
echo "${SSH_TERRAFORM_PUBLIC_KEY}" >> /home/ubuntu/.ssh/authorized_keys

# Configurar credenciales AWS
mkdir -p /home/ubuntu/.aws/
touch /home/ubuntu/.aws/credentials
echo "[default]" | tee -a /home/ubuntu/.aws/credentials
echo "aws_access_key_id=${AWS_ACCESS_KEY_ID}" | tee -a /home/ubuntu/.aws/credentials
echo "aws_secret_access_key=${AWS_SECRET_ACCESS_KEY}" | tee -a /home/ubuntu/.aws/credentials
echo "region=${AWS_REGION}" | tee -a /home/ubuntu/.aws/credentials

# Crear red de Docker
sudo docker network create --driver=bridge ${DOCKER_NETWORK_NAME}

# Escribir logs de despliegue
sudo mkdir -p /mnt/efs/logs
echo "Deploy instance: ${AMI} IP: ${AWS_IP_EIPALLOC} ${INSTANCE} - $(date)" | sudo tee -a /mnt/efs/logs/deploys-prod.log


# auxiliar
touch /home/ubuntu/deploy.sh
echo "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_REPO_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com" >> /home/ubuntu/deploy.sh
echo "docker pull ${AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/nginx_prod:latest" >> /home/ubuntu/deploy.sh
echo "docker run --rm --net app -d -p 80:80 -p 443:443 -v /mnt/efs/prod/nginx/letsencrypt:/etc/letsencrypt -v /mnt/efs/prod/nginx/conf.d:/etc/nginx/conf.d -v /mnt/efs/prod/nginx/log/access.log:/var/log/nginx/access.log:rw -v /mnt/efs/prod/nginx/log/error.log:/var/log/nginx/error.log:rw -v /mnt/efs/prod/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -v /mnt/efs/prod/nginx/www:/usr/share/nginx/www:ro --name proxy-ng ${AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/nginx_prod:latest" >> /home/ubuntu/deploy.sh
chmod +x /home/ubuntu/deploy.sh

aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_REPO_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
docker pull ${AWS_ECR_REPO_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/nginx_prod:latest
docker run --rm --net app -d -p 80:80 -p 443:443 -v /mnt/efs/prod/nginx/letsencrypt:/etc/letsencrypt -v /mnt/efs/prod/nginx/conf.d:/etc/nginx/conf.d -v /mnt/efs/prod/nginx/log/access.log:/var/log/nginx/access.log:rw -v /mnt/efs/prod/nginx/log/error.log:/var/log/nginx/error.log:rw -v /mnt/efs/prod/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -v /mnt/efs/prod/nginx/www:/usr/share/nginx/www:ro --name proxy-ng ${AWS_ECR_REPO_ID}.dkr.ecr.us-east-1.amazonaws.com/nginx_prod:latest

# p.neogaleno.com 44.214.254.160
# mobile.neogaleno.com a 44.214.254.160

# ip ***.185 stg
# t.neogaleno.com 35.171.248.185
# mobile-stg.neogaleno.com a 35.171.248.185
