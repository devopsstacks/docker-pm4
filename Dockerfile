# Base Image
FROM amazonlinux:2017.09

# Maintainer
LABEL maintainer="devops@processmaker.com"

LABEL processmaker-stack="pm4"

# Install processmaker 
COPY ["script-config/installpm.sh", "/tmp/"]
COPY ["script-config/pmoptional.sh", "/tmp/"]
COPY ["script-config/servicespm.sh", "/usr/bin/"]
RUN  chmod 700 /tmp/installpm.sh && \
     chmod 700 /tmp/pmoptional.sh && \
     chmod 700 /usr/bin/servicespm.sh && \
     /bin/sh /tmp/installpm.sh      
COPY ["file-config/php-fpm.conf", "/etc/php-fpm.d/processmaker.conf"]
COPY ["file-config/nginx.conf", "/etc/nginx/nginx.conf"]
COPY ["file-config/processmaker.conf", "/etc/nginx/conf.d/processmaker.conf"]
COPY ["file-config/processmaker-horizon.conf", "/etc/supervisor/processmaker-horizon.conf"]
COPY ["file-config/processmaker-echo-server.conf", "/etc/supervisor/processmaker-echo-server.conf"]

# Docker entrypoint
EXPOSE 80 6001
ENTRYPOINT ["/usr/bin/servicespm.sh"]