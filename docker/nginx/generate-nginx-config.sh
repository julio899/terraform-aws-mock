#!/bin/bash


# Ruta al archivo de dominios
archivo="domains.txt"
# VARIABLES NECESARIAS PARA TEMPLATE
# __DOMAIN__ & __HOST__
# while IFS= read -r dominio; do

certbot --version
sleep 2


# Verificar si el archivo de template existe
if [ ! -f "/etc/letsencrypt/options-ssl-nginx.conf" ]; then
    echo "El archivo /etc/letsencrypt/options-ssl-nginx.conf no existe."
    wget https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf -P /etc/letsencrypt/ -c
fi

# Comprobar si el directorio existe
if [ ! -d "/etc/letsencrypt/live/" ]; then
  echo "El directorio /etc/letsencrypt/live/ no existe. Creando..."
  mkdir -p "/etc/letsencrypt/live/"
  echo "Directorio creado."
else
  echo "El directorio $directorio ya existe."
fi

cd /etc/nginx/
# Leer cada línea del archivo con el dominio y host
# while IFS=' ' read -r dominio host; do
while IFS=' ' read -r dominio host || [ -n "$dominio" ]; do
  # request ssl --dry-run
  cp -r sites/** /etc/letsencrypt/live/
  # IMPORTANT FOR NEW DOMAINS
  # certbot certonly --nginx -d $dominio --non-interactive --agree-tos -m info@$dominio
  # sleep 5

  sed -e "s|__DOMAIN__|$dominio|g" templates/template_ssl.tmpl > $dominio.tmp && mv $dominio.tmp templates/$dominio.txt
  sed -e "s|__HOST__|$host|g" templates/$dominio.txt > $dominio.tmp && mv $dominio.tmp /etc/nginx/conf.d/$dominio.conf
  rm templates/$dominio.txt
  echo $PWD
  # Imprimir el dominio
  echo "Dominio: $dominio  - host $host"
  echo "file: /etc/nginx/conf.d/$dominio.conf"
  sleep 1
done < "$archivo"
nginx -T
service nginx reload
service nginx status
