#!/bin/bash

# Variables
string_a_reemplazar="my_valor"
nuevo_string="algodon"
archivo_template="f.txt"
archivo_salida="f_nuevo.txt"

# Verificar si el archivo de template existe
if [ ! -f "$archivo_template" ]; then
    echo "El archivo $archivo_template no existe."
    exit 1
fi

# Realizar el reemplazo y guardar en un archivo nuevo
sed "s/${string_a_reemplazar}/${nuevo_string}/g" "$archivo_template" > "$archivo_salida"

echo "El reemplazo se realizó correctamente. El nuevo archivo es $archivo_salida."


sed -e "s/# ssl_certificate/ssl_certificate/g" sites/ng.topacio.link.conf > ng.topacio.link.txt
sed -e "s/# include \/etc\/letsencrypt/# include \/etc\/letsencrypt/g" ng.topacio.link.txt > ng.topacio.link.txt





sed -e "s|listen 80|# listen 80|g" sites/ng.topacio.link.conf > ng.topacio.link.tmp && mv ng.topacio.link.tmp ng.topacio.link.txt && sed -e "s|# listen 443|listen 443|g" ng.topacio.link.txt > ng.topacio.link.tmp && mv ng.topacio.link.tmp ng.topacio.link.txt && sed -e "s|# ssl_dhparam|ssl_dhparam|g" ng.topacio.link.txt > ng.topacio.link.tmp && mv ng.topacio.link.tmp ng.topacio.link.txt && sed -e "s|# ssl_certificate|ssl_certificate|g" ng.topacio.link.txt > ng.topacio.link.tmp && mv ng.topacio.link.tmp ng.topacio.link.txt && sed -e "s|# include /etc/letsencrypt|include /etc/letsencrypt|g" ng.topacio.link.txt > ng.topacio.link.tmp && mv ng.topacio.link.tmp ng.topacio.link.conf && rm ng.topacio.link.txt