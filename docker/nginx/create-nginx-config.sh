#!/bin/bash


template_="template_host.tmpl"
echo $listado
echo "domain: $1"
echo "host: $2"



cd /etc/nginx/
# Verificar si el archivo de template existe
if [ -f "templates/$template_" ]; then
    # generate minimal config port 80
    echo " - El archivo templates/$template_ existe."
   sed -e "s|__DOMAIN__|$1|g" templates/$template_ > $1.tmp && mv $1.tmp templates/$1.txt
   sed -e "s|__HOST__|$2|g" templates/$1.txt > $1.tmp && mv $1.tmp /etc/nginx/conf.d/$1.conf
   # local templates/$1.conf
   # FINAL /etc/nginx/conf.d/$1.conf
   rm templates/$1.txt
fi

certbot certonly --nginx -d $1 --non-interactive --agree-tos -m info@$1
certbot install --cert-name $1 --nginx


nginx -T
service nginx reload
service nginx status
