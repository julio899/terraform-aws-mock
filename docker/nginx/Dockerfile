FROM nginx
# COPY default.conf /etc/nginx/conf.d/default.conf

# instalar dependencias
RUN apt update -y && apt upgrade -y
RUN apt install nano curl build-essential python3 python3-venv libaugeas0 tar htop wget -y

RUN apt-get autoremove -y && apt-get clean
RUN python3 -m venv /opt/certbot/
RUN /opt/certbot/bin/pip install --upgrade pip
RUN /opt/certbot/bin/pip install certbot
RUN apt install python3-certbot-nginx -y


COPY create-nginx-config.sh /usr/local/sbin/create-nginx-config
COPY generate-nginx-config.sh /usr/local/sbin/nginx-generate-config-domains

RUN chmod +x /usr/local/sbin/create-nginx-config
RUN chmod +x /usr/local/sbin/nginx-generate-config-domains


RUN mkdir -p /etc/nginx/templates/
RUN mkdir -p /etc/nginx/sites/
COPY templates/ /etc/nginx/templates/
COPY domains.txt /etc/nginx/
COPY letsencrypt/live/ /etc/nginx/sites/
