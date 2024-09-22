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