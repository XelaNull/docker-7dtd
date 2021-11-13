FROM steamcmd/steamcmd:centos-7 as builder
FROM centos:7

# Define configuration parameters
ENV TIMEZONE="America/New_York" \
    TELNET_PORT="8081" \
    INSTALL_DIR=/data/7DTD
#ARG TELNET_PW
#ENV TELNET_PW=$TELNET_PW

VOLUME ["/data"]

# Copy Supervisor Config Creator
COPY files/gen_sup.sh /

# Copy ServerMod Manager Files into Image
COPY 7dtd-servermod/* /7dtd-servermod/
COPY 7dtd-servermod/files/* /
COPY 7dtd-servermod/images/* /7dtd-servermod/images/

# Copy Steam files from builder
COPY --from=builder /usr/lib/games/steam/steamcmd.sh /usr/lib/games/steam/
COPY --from=builder /usr/lib/games/steam/steamcmd /usr/lib/games/steam/
COPY --from=builder /usr/bin/steamcmd /usr/bin/steamcmd
#COPY --from=builder /etc/pki/tls/certs /etc/pki/tls/certs
#COPY --from=builder /usr/lib /usr/lib/

# Set up Steam working directories
RUN mkdir -p ~/.steam/appcache ~/.steam/config ~/.steam/logs ~/.steam/SteamApps/common ~/.steam/steamcmd/linux32 && \
    ln -s ~/.steam ~/.steam/root && \
    ln -s ~/.steam ~/.steam/steam && \
    cp -p /usr/lib/games/steam/steamcmd.sh ~/.steam/steamcmd/ && \
    cp -p /usr/lib/games/steam/steamcmd ~/.steam/steamcmd/linux32/ && \
    chmod a+x ~/.steam/steamcmd/steamcmd.sh && \
    chmod a+x ~/.steam/steamcmd/linux32/steamcmd

# Install base YUM packages required
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*
RUN yum -y install epel-release && \
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*
RUN yum -y install glibc.i686 libstdc++.i686 supervisor telnet expect net-tools sysvinit-tools nginx php-fpm php-cli && \
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*

# Install Tools to Extract Mods
RUN yum -y install unzip p7zip p7zip-plugins curl svn git wget && \
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/* && \
    wget --no-check-certificate https://www.rarlab.com/rar/rarlinux-x64-5.5.0.tar.gz && \
    tar -zxf rarlinux-*.tar.gz && cp rar/rar rar/unrar /usr/local/bin/ && \
    rm -rf rar* rarlinux-x64-5.5.0.tar.gz

# Deploy the Nginx & FPM Config files
COPY nginx-config/nginx.conf /etc/nginx/nginx.conf
COPY nginx-config/fpm-pool.conf /etc/php-fpm.d/www.conf
COPY nginx-config/php.ini /etc/php.d/custom.ini

# Configure Supervisor
RUN printf '[supervisord]\nnodaemon=true\nuser=root\nlogfile=/var/log/supervisord\n' > /etc/supervisord.conf
RUN /gen_sup.sh php8-fpm "php-fpm -F" >> /etc/supervisord.conf && \
    /gen_sup.sh nginx "nginx -g 'daemon off;'" >> /etc/supervisord.conf && \
    /gen_sup.sh severmod-cntrl "/servermod-cntrl.php $INSTALL_DIR" >> /etc/supervisord.conf && \
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

# Set to start the supervisor daemon on bootup
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:80/fpm-ping
