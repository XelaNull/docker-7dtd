FROM alpine:latest

VOLUME ["/data"]
RUN mkdir -p /7dtd-servermod/image
COPY files/* /
COPY servermod/* /7dtd-servermod/
COPY servermod/images/* /7dtd-servermod/images/

COPY nginx-config/nginx.conf /etc/nginx/nginx.conf
COPY nginx-config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY nginx-config/php.ini /etc/php8/conf.d/custom.ini
COPY nginxconfig/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN apk add --no-cache supervisor nginx php8 php8-fpm php8-cli curl && \
    ln -s /usr/bin/php8 /usr/bin/php

RUN apk add --no-cache telnet expect wget net-tools sudo git svn

# unzip p7zip p7zip-plugins

RUN printf '[supervisord]\nnodaemon=true\nuser=root\nlogfile=/var/log/supervisord\n' > /etc/supervisord.conf
# Create script to add more supervisor boot-time entries
    echo $'#!/bin/bash \necho "[program:$1]";\necho "process_name  = $1";\n\
echo "autostart     = true";\necho "autorestart   = false";\necho "directory     = /";\n\
echo "command       = $2";\necho "startsecs     = 3";\necho "priority      = 1";\n\n' > /gen_sup.sh && \
    chmod a+x /gen_sup.sh

RUN /gen_sup.sh crond "crond -f -l 8" >> /etc/supervisord.conf && \
    /gen_sup.sh php8-fpm "php-fpm8 -F" >> /etc/supervisord.conf && \
    /gen_sup.sh nginx "nginx -g 'daemon off;'" >> /etc/supervisord.conf

# ServerMod Manager
EXPOSE 80/tcp
EXPOSE 8080/tcp
# 7DTD Telnet Port
EXPOSE 8081/tcp
EXPOSE 8082/tcp
# 7DTD Gameports
EXPOSE 26900/tcp
EXPOSE 26900/udp
EXPOSE 26901/udp
EXPOSE 26902/udp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
