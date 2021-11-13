FROM steamcmd/steamcmd:alpine as builder
FROM alpine:latest

ENV INSTALL_DIR=/data/7DTD

VOLUME ["/data"]

# Copy Supervisor Config Creator
COPY files/gen_sup.sh /

# Copy ServerMod Manager Files into Image
COPY 7dtd-servermod/* /7dtd-servermod/
COPY 7dtd-servermod/files/* /
COPY 7dtd-servermod/images/* /7dtd-servermod/images/

# Copy Nginx & PHP Files into Image
COPY nginx-config/nginx.conf /etc/nginx/nginx.conf
COPY nginx-config/fpm-pool.conf /etc/php8/php-fpm.d/www.conf
COPY nginx-config/php.ini /etc/php8/conf.d/custom.ini

RUN apk add --no-cache busybox-extras expect wget net-tools sudo git subversion \
    p7zip unrar unzip supervisor nginx php8 php8-fpm php8-cli curl bash && \
    ln -s /usr/bin/php8 /usr/bin/php

# Copy steamcmd files from builder
COPY --from=builder /usr/lib/games/steam/steamcmd.sh /usr/lib/games/steam/
COPY --from=builder /usr/lib/games/steam/steamcmd /usr/lib/games/steam/
COPY --from=builder /usr/bin/steamcmd /usr/bin/steamcmd

# Copy required files from builder
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /lib /lib/

# Set up Steam working directories
RUN mkdir -p ~/.steam/appcache ~/.steam/config ~/.steam/logs ~/.steam/SteamApps/common ~/.steam/steamcmd/linux32 && \
    ln -s ~/.steam ~/.steam/root && \
    ln -s ~/.steam ~/.steam/steam && \
    cp -p /usr/lib/games/steam/steamcmd.sh ~/.steam/steamcmd/ && \
    cp -p /usr/lib/games/steam/steamcmd ~/.steam/steamcmd/linux32/ && \
    chmod a+x ~/.steam/steamcmd/steamcmd.sh && \
    chmod a+x ~/.steam/steamcmd/linux32/steamcmd

#RUN echo "*    *       *       *       *       run-parts /etc/periodic/1min" >> /etc/crontabs/root && \
#    mkdir /etc/periodic/1min && \
#    echo "/loop_start_7dtd.sh" > /etc/periodic/1min/loop_wrapper.sh && \
#    chmod a+x /etc/periodic/1min/loop_wrapper.sh

RUN printf '[supervisord]\nnodaemon=true\nuser=root\nlogfile=/var/log/supervisord\n' > /etc/supervisord.conf

RUN ls -l / && chmod a+x /*.sh
RUN /gen_sup.sh crond "crond -f -l 8" >> /etc/supervisord.conf && \
    /gen_sup.sh php8-fpm "php-fpm8 -F" >> /etc/supervisord.conf && \
    /gen_sup.sh nginx "nginx -g 'daemon off;'" >> /etc/supervisord.conf && \
    /gen_sup.sh severmod-cntrl "/7dtd-servermod-daemon.php $INSTALL_DIR" >> /etc/supervisord.conf && \
    /gen_sup.sh 7dtd-daemon "/7dtd-daemon.sh" >> /etc/supervisord.conf

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

WORKDIR ["/data"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping
