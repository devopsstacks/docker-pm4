#!/bin/bash
set -e ;
cp /etc/hosts ~/hosts.new ;
sed -i "/127.0.0.1/c\127.0.0.1 localhost localhost.localdomain `hostname`" ~/hosts.new ;
cp -f ~/hosts.new /etc/hosts ;

#exec /usr/sbin/init ;

service sendmail start ;
service php-fpm start ;

if [ -f /opt/processmaker/public/index.php ];
then
    echo "ProccessMaker 4 is already installed";
else
    /bin/sh /tmp/pmoptional.sh ;
fi

echo "
       ░░░░░░░
    ░░░░░░░░░░░░░
   ░░░░       ░░░░     WELCOME TO PROCESSMAKER 4 -> ( amazonlinux:2017.09 ; NGINX-1.12 ; PHP-7.2 )
  ░░░░  ░░░░░   ░░░
  ░░░  ░░░░░░░  ░░░░   - This ProcessMaker Stack uses MySql 5.7
  ░░░  ░░░░░░   ░░░    - The following command runs mysql57 in Docker:
   ░░  ░░     ░░░░     -> docker run --name pm-db57 -e MYSQL_ROOT_PASSWORD=PM-Testdb -e MYSQL_DATABASE=pm4 -p 3306:3306 -d mysql:5.7
    ░  ░░░░░░░░░       
       ░░░░░░░         
	 " ; 
sleep 3 ;
service redis-server start ;
service php-fpm restart ;
if [ -d "/opt/processmaker/storage/logs/" ] ; then /usr/local/bin/supervisord -c /etc/supervisor/supervisord.conf && /usr/local/bin/supervisorctl reload ; fi
service nginx stop ;
nginx -g 'daemon off;' ;