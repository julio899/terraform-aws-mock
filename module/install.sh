#!/bin/bash

# Actualizar e instalar dependencias
sudo apt update -y
sudo apt install nfs-common -y
# Montar EFS
sudo mkdir -p /mnt/efs
sudo nslookup ${URL_DISK_EFS}
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

echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} && export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} && export AWS_DEFAULT_REGION=us-east-1 && aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 202533523551.dkr.ecr.us-east-1.amazonaws.com" >> ~/.profile
     


# login AWS
 . ~/.profile
aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_REPO_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com


# crear dir de montado
sudo mkdir -p /mnt/data

# mount Disk SSD
aws ec2 attach-volume \
    --volume-id ${AWS_VOLUME} \
    --instance-id ${EC2_ID} \
    --device /dev/sdf
sudo mount /dev/xvdf /mnt/data
sudo echo '/dev/xvdf  /mnt/data  ext4  defaults,nofail  0  0' >> /etc/fstab

# --- Logica de almacenamiento de docker --- #
sudo mkdir -p /mnt/data/docker/data-root
# sudo systemctl stop docker
sudo service docker stop
# sudo systemctl disable docker.service
# sudo systemctl disable docker.socket
echo '{"data-root": "/mnt/data/docker/data-root"}' | sudo tee /etc/docker/daemon.json
# sudo systemctl enable docker
sudo service docker start

sleep 3 | echo 'docker starting' | docker -v

######################################
# IMPORTANTE TODOS LOS CONTAINERS
# ASIGNAR MISMA RED PARA COMUNICACION
######################################
# Crear red de Docker #

# Verificar si la red existe
if ! docker network inspect "$DOCKER_NETWORK_NAME" > /dev/null 2>&1; then
    # Si la red no existe, crearla
   sudo docker network create --driver=bridge ${DOCKER_NETWORK_NAME} 
else
    echo "Red '$DOCKER_NETWORK_NAME' ya existe."
fi

# Escribir logs de despliegue
sudo mkdir -p /mnt/efs/logs
echo "Deploy instance: ${AMI} IP: ${AWS_IP_EIPALLOC} ${INSTANCE} - $(date)" | sudo tee -a /mnt/efs/logs/deploys-prod.log


aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ECR_REPO_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

# sync images
docker pull ${AWS_ECR_REPO_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/nginx_prod:latest


## ------------------
# api run container
cd /mnt/efs/prod/git/ng-api/
docker run -d --rm --name rabbitmq_container --network app --hostname rabbitqm -p 15672:15672 -p 5672:5672 rabbitmq:3.12-management
docker build -f Dockerfile.prod -t api-neogaleno-prod .
docker run -d --rm -p 4141:4141 --name api_container --network app -v /mnt/efs/prod/git/ng-api/.env:/app/.env -e RABBITMQ_HOST=rabbitmq_container api-neogaleno-prod:latest
# docker exec -it api_container /bin/bash
####### [ close module API ] #######
## -------------------------------


## -------------------------------
# AI container & BD              #
## -------------------------------
cd /mnt/efs/prod/git/neo-ai-api/
docker build -t neo-ai-app .
# run posgresql 
docker run --rm --net app --name postgresql-prod \
   -p 5432:5432 \
   -e POSTGRES_USER=ai \
   -e POSTGRES_PASSWORD=neogaleno \
   -e POSTGRES_DB=neo_ai_db \
   -e TZ=America/Mexico_City \
   -v /mnt/efs/prod/postgres:/var/lib/postgresql/data \
   -d postgres

####### app python docker #######
docker run --rm --net app -d --name ai-prod \
   -v  /mnt/efs/prod/git/neo-ai-api/.env.prod:/app/.env \
   -p 8000:8000 \
   neo-ai-app
####### [ close module AI ] #######
## -------------------------------


# FRONT
cd /mnt/efs/prod/git/ng-front
docker-compose -f docker-compose-prod.yml up -d
docker network connect app front-prod

# Proxy with certbot
docker run --rm --net app -d -p 80:80 -p 443:443 \
     -v /mnt/efs/prod/nginx/create-nginx-config-static.sh:/usr/local/sbin/create-nginx-config-static \
     -v /mnt/efs/prod/nginx/templates:/etc/nginx/templates:ro \
     -v /mnt/efs/prod/nginx/letsencrypt:/etc/letsencrypt \
     -v /mnt/efs/prod/nginx/conf.d:/etc/nginx/conf.d \
     -v /mnt/efs/prod/nginx/log/access.log:/var/log/nginx/access.log:rw \
     -v /mnt/efs/prod/nginx/log/error.log:/var/log/nginx/error.log:rw \
     -v /mnt/efs/prod/nginx/nginx.conf:/etc/nginx/nginx.conf:rw \
     -v /mnt/efs/prod/nginx/www:/usr/share/nginx/www:rw \
     --name proxy-ng ${AWS_ECR_REPO_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/nginx_prod:latest
