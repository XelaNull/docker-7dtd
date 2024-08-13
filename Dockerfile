FROM steamcmd/steamcmd:rocky-8 as builder
FROM almalinux:8

# 461MB Compressed
# 511MB Uncompressed

# Define configuration parameters
ENV TIMEZONE="America/New_York" \
    TELNET_PORT="8081" \
    INSTALL_DIR=/data/7DTD
#ARG TELNET_PW
#ENV TELNET_PW=$TELNET_PW

ENV REFRESHED_AT=2024-08-11

VOLUME ["/data"]

# Copy Supervisor Config Creator
COPY files/gen_sup.sh /
# Install PHP7 from Remi Repo
RUN dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm && \
    dnf module reset php -y && \
    dnf module install php:remi-8.0 -y

# Copy ServerMod Manager Files into Image
RUN dnf -y install git epel-release procps && \
    dnf clean all && rm -rf /tmp/* && rm -rf /var/tmp/* && \
    cd / && git clone https://github.com/XelaNull/docker-7dtd.git && \
    ln -s /docker-7dtd/7dtd-servermod/files/7dtd-daemon.sh && \
    ln -s /docker-7dtd/7dtd-servermod/files/7dtd-sendcmd.php && \
    ln -s /docker-7dtd/7dtd-servermod/files/7dtd-sendcmd.sh && \
    ln -s /docker-7dtd/7dtd-servermod/files/7dtd-upgrade.sh && \
    ln -s /docker-7dtd/7dtd-servermod/files/servermod-cntrl.php && \
    ln -s /docker-7dtd/7dtd-servermod/files/start_7dtd.sh && \
    ln -s /docker-7dtd/7dtd-servermod/files/stop_7dtd.sh

# Copy Steam files from builder
COPY --from=builder /usr/lib/games/steam/steamcmd.sh /usr/lib/games/steam/
COPY --from=builder /usr/lib/games/steam/steamcmd /usr/lib/games/steam/
COPY --from=builder /usr/bin/steamcmd /usr/bin/steamcmd

# Set up Steam working directories
RUN mkdir -p ~/.steam/appcache ~/.steam/config ~/.steam/logs ~/.steam/SteamApps/common ~/.steam/steamcmd/linux32 && \
    ln -s ~/.steam ~/.steam/root && \
    ln -s ~/.steam ~/.steam/steam && \
    cp -p /usr/lib/games/steam/steamcmd.sh ~/.steam/steamcmd/ && \
    cp -p /usr/lib/games/steam/steamcmd ~/.steam/steamcmd/linux32/ && \
    chmod a+x ~/.steam/steamcmd/steamcmd.sh && \
    chmod a+x ~/.steam/steamcmd/linux32/steamcmd

# Install base YUM packages required
RUN dnf -y install nginx && \
    dnf clean all && rm -rf /tmp/* && rm -rf /var/tmp/*

#2024-08-11: Removed sysvinit-tools -- not sure what the ramifications of this are
RUN dnf -y install glibc.i686 libstdc++.i686 supervisor telnet expect net-tools && \
    dnf clean all && rm -rf /tmp/* && rm -rf /var/tmp/*

# Install Tools to Extract Mods
#RUN dnf -y install svn
RUN dnf -y install unzip p7zip p7zip-plugins curl wget && \
    dnf clean all && rm -rf /tmp/* && rm -rf /var/tmp/* && \
    wget --no-check-certificate https://www.rarlab.com/rar/rarlinux-x64-5.5.0.tar.gz && \
    tar -zxf rarlinux-*.tar.gz && cp rar/rar rar/unrar /usr/local/bin/ && \
    rm -rf rar* rarlinux-x64-5.5.0.tar.gz

# Deploy the Nginx & FPM Config files
COPY nginx-config/nginx.conf /etc/nginx/nginx.conf
COPY nginx-config/fpm-pool.conf /etc/php-fpm.d/www.conf
COPY nginx-config/php.ini /etc/php.d/custom.ini

# Configure Supervisor
RUN printf '[supervisord]\nnodaemon=true\nuser=root\nlogfile=/var/log/supervisord\n' > /etc/supervisord.conf
RUN /gen_sup.sh php-fpm "/start-fpm.sh" >> /etc/supervisord.conf && \
    /gen_sup.sh nginx "nginx -g 'daemon off;'" >> /etc/supervisord.conf && \
    /gen_sup.sh severmod-cntrl "/servermod-cntrl.php $INSTALL_DIR" >> /etc/supervisord.conf && \
    /gen_sup.sh 7dtd-daemon "/7dtd-daemon.sh" >> /etc/supervisord.conf && \
    /gen_sup.sh own-mods "/Mods-ownership-fix.sh" >> /etc/supervisord.conf

# Create startup script for php-fpm
RUN printf '#!/bin/bash\nmkdir /run/php-fpm;\n/usr/sbin/php-fpm -F' > /start-fpm.sh && \
    chmod a+x /start-fpm.sh

# Set up the Kernel tuning parameter for 7DTD Server
RUN printf 'vm.max_map_count=262144' > /etc/sysctl.d/7dtd.conf

RUN printf 'chown nginx /data/7DTD/Mods; chown nginx /data/7DTD/server.expected_status; chown nginx /data/7DTD/serverconfig.xml' > /Mods-ownership-fix.sh && \
    chmod a+x /Mods-ownership-fix.sh

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

# Set to start the supervisor daemon on bootup
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

#HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping
