FROM nginx
# COPY default.conf /etc/nginx/conf.d/default.conf
# instalar dependencias
RUN apt update -y && apt upgrade -y
RUN apt install nano curl build-essential python3 python3-venv libaugeas0 tar python3-certbot-nginx htop wget -y
RUN apt-get autoremove -y && apt-get clean
RUN python3 -m venv /opt/certbot/
RUN /opt/certbot/bin/pip install --upgrade pip
RUN /opt/certbot/bin/pip install certbot
# RUN ln -s /opt/certbot/bin/certbot /usr/bin/certbot
# RUN echo "0 0,12 * * * root /opt/certbot/bin/python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew -q" | tee -a /etc/crontab > /dev/null
# RUN mkdir -p /etc/nginx/conf.d/
# COPY $PWD/sites/ng.topacio.link.conf /etc/nginx/conf.d/ng.topacio.link.conf

# COPY letsencrypt /etc/
# doninio previamente necesita que este corriendo el servicio
COPY ./sites/ng.topacio.link.conf /etc/nginx/conf.d

# RUN certbot --nginx
# CMD ["service nginx reload && sleep 1 && certbot certonly --nginx"]
# CMD ["service nginx reload"]
# CMD [ "ln -s /opt/certbot/bin/certbot /usr/bin/certbot" ]


# test local
# docker run -it -p 8080:80 -d --name proxy-ng nginx_front:latest

# entrar 
# docker exec -ti proxy-ng /bin/bash

# add domain
# certbot certonly --nginx -d www.algo.don --non-interactive --agree-tos -m info@topacio.link