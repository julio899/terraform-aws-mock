# run container
docker run -it --rm -d -p 80:80 --name web nginx

docker network ls
bridge

# docker Enter
docker exec -ti proxy-ng /bin/bash
docker exec -ti 0a5903c2b25f /bin/bash
apt install nano curl iputils-ping


# configuracion del default
/etc/nginx/conf.d/default.conf
location / {
         proxy_set_header Host               $host;
         proxy_set_header X-Real-IP          $remote_addr;
         proxy_set_header X-Forwarded-For    $proxy_add_x_forwarded_for;
         proxy_pass http://front-stg:3030;
    }


# create network
docker network create -d bridge app_stg

# add network in comand docker
--net myapp_default

# change container network
docker run -itd --network=mynet busybox
    If you want to add a container to a network after the container is already running, use the 
docker network connect your-network-name container-name
docker network connect bridge front-stg

docker run -it --rm --link front-stg:front-stg -d -p 80:80 -p 443:443 --name proxy-ng --net app_stg nginx





# template y remplazo en archivos
sed -e "s/my_valor/bello calidad/g" f.txt > t.txt


# Cambiar el Docker Root Directory a EFS
El directorio raíz de Docker (donde guarda imágenes, contenedores y volúmenes) por defecto está en /var/lib/docker. Puedes cambiar esta ubicación para que utilice el volumen EFS.

sudo systemctl stop docker
sudo mkdir -p /mnt/efs/docker

Configura Docker para usar este nuevo directorio como su raíz. Edita el archivo de configuración de Docker (/etc/docker/daemon.json) para especificar el nuevo data-root:
    sudo nano /etc/docker/daemon.json
    {
    "data-root": "/mnt/efs/docker"
    }

Mueve los datos existentes de Docker al nuevo directorio en EFS:
    sudo rsync -aP /var/lib/docker/ /mnt/efs/docker/

Reinicia Docker:
    sudo systemctl start docker

# Opción 2: Montar Volúmenes de Docker en EFS
    docker run -v /mnt/efs/app-data:/app-data my-container
