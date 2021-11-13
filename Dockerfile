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

# Install Webtatic (PHP YUM Repo)
RUN mkdir -p /7dtd-servermod/images

# Copy 7DTD ServerMod Manager Files into Place
COPY files/* /
COPY servermod/* /7dtd-servermod/
COPY servermod/images/* /7dtd-servermod/images/

# Create beginning of supervisord.conf file
RUN printf '[supervisord]\nnodaemon=true\nuser=root\nlogfile=/var/log/supervisord\n' > /etc/supervisord.conf && \
# Create start_httpd.sh script
    printf '#!/bin/bash\nrm -rf /run/httpd/httpd.pid\nwhile true; do\n/usr/sbin/httpd -DFOREGROUND\nsleep 10\ndone' > /start_httpd.sh && \
# Create start_supervisor.sh script
    printf '#!/bin/bash\n/usr/bin/supervisord -c /etc/supervisord.conf' > /start_supervisor.sh && \
# Create Cron start script
    printf '#!/bin/bash\n/usr/sbin/crond -n\n' > /start_crond.sh && \
# Create script to add more supervisor boot-time entries
    echo $'#!/bin/bash \necho "[program:$1]";\necho "process_name  = $1";\n\
echo "autostart     = true";\necho "autorestart   = false";\necho "directory     = /";\n\
echo "command       = $2";\necho "startsecs     = 3";\necho "priority      = 1";\n\n' > /gen_sup.sh

# Install extra non-required things
# RUN yum -y install vim-enhanced python rsync mlocate
# RUN yum -y install gcc-c++ glibc.i686 libstdc++.i686 logrotate which

# Install daemon packages# Install base packages
RUN yum -y install supervisor telnet expect unzip wget net-tools sudo git p7zip p7zip-plugins sysvinit-tools svn cronie curl && \
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*

RUN chmod a+x /*.sh /*.php && \
    wget --no-check-certificate https://www.rarlab.com/rar/rarlinux-x64-5.5.0.tar.gz && \
    tar -zxf rarlinux-*.tar.gz && cp rar/rar rar/unrar /usr/local/bin/ && \
    rm -rf rar* rarlinux-x64-5.5.0.tar.gz

#RUN yum -y install https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
#RUN yum -y install sqlite
#RUN yum -y install php72w-cli httpd mod_php72w php72w-opcache php72w-curl php72w-sqlite3 php72w-gd

#RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
#    yum -y --enablerepo=remi-php73 install http php php-common php-opcache php-pecl-mcrypt php-cli php-curl && \
#    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*

RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum install nginx php-fpm php-cli && \
    yum clean all && rm -rf /tmp/* && rm -rf /var/tmp/*


# STEAMCMD
RUN useradd steam

# Set the Apache WEB_PORT
# Reconfigure Apache to run under steam username, to retain ability to modify steam's files
RUN rm -rf /etc/httpd/conf.d/welcome.conf && \
    sed -i "s/Listen 80/Listen $WEB_PORT/g" /etc/httpd/conf/httpd.conf && \
    sed -i 's|User apache|User steam|g' /etc/httpd/conf/httpd.conf && \
    sed -i 's|Group apache|Group steam|g' /etc/httpd/conf/httpd.conf && \
    chown steam /var/lib/php -R && \
    chown steam:steam /var/www/html -R && \
    echo $'Alias "/7dtd" "/data/7DTD/html"\n<Directory "/data/7DTD">\n\tRequire all granted\n\tOptions all\n\tAllowOverride all\n</Directory>\n' > /etc/httpd/conf.d/7dtd.conf

# Create different supervisor entries
RUN su - steam -c "(/usr/bin/crontab -l 2>/dev/null; echo '* * * * * /loop_start_7dtd.sh') | /usr/bin/crontab -" && \
    /gen_sup.sh crond "/start_crond.sh" >> /etc/supervisord.conf && \
    /gen_sup.sh httpd "/start_httpd.sh" >> /etc/supervisord.conf && \
    /gen_sup.sh 7dtd-daemon "/7dtd-daemon.php /data/7DTD" >> /etc/supervisord.conf

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
ENTRYPOINT ["/start_supervisor.sh"]
