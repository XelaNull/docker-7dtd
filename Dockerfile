# CentOS7 Minimal
FROM centos:7
# Set the local timezone
ENV TIMEZONE="America/New_York" \
    TELNET_PORT="8081"
#ARG TELNET_PW
#ENV TELNET_PW=$TELNET_PW
ENV INSTALL_DIR=/data/7DTD
ENV WEB_PORT=80

VOLUME ["/data"]

# Copy Supervisor Config Creator
COPY files/gen_sup.sh /

# Copy ServerMod Manager Files into Image
COPY 7dtd-servermod/* /7dtd-servermod/
COPY 7dtd-servermod/files/* /
COPY 7dtd-servermod/images/* /7dtd-servermod/images/

# Create beginning of supervisord.conf file
RUN printf '[supervisord]\nnodaemon=true\nuser=root\nlogfile=/var/log/supervisord\n' > /etc/supervisord.conf

# Install base YUM packages required
RUN yum -y install epel-release && yum -y install glibc.i686 libstdc++.i686 supervisor telnet expect unzip wget \
    net-tools git p7zip p7zip-plugins sysvinit-tools svn curl && \
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*

# Install Unrar
RUN chmod a+x /*.sh /*.php && \
    wget --no-check-certificate https://www.rarlab.com/rar/rarlinux-x64-5.5.0.tar.gz && \
    tar -zxf rarlinux-*.tar.gz && cp rar/rar rar/unrar /usr/local/bin/ && \
    rm -rf rar* rarlinux-x64-5.5.0.tar.gz


# NGINX:
# Remi Nginx + PHP 7.3 = 457MB total, 75MB
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum -y install nginx php-fpm php-cli && \
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*

COPY nginx-config/nginx.conf /etc/nginx/nginx.conf
COPY nginx-config/fpm-pool.conf /etc/php-fpm.d/www.conf
COPY nginx-config/php.ini /etc/php.d/custom.ini

RUN /gen_sup.sh php8-fpm "php-fpm -F" >> /etc/supervisord.conf && \
    /gen_sup.sh nginx "nginx -g 'daemon off;'" >> /etc/supervisord.conf
#    /gen_sup.sh severmod-cntrl "/servermod-cntrl.php $INSTALL_DIR" >> /etc/supervisord.conf && \
#    /gen_sup.sh 7dtd-daemon "/7dtd-daemon.sh" >> /etc/supervisord.conf

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
