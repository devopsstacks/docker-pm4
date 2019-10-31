#!/bin/bash

    if [[ -z "${PM_URL}" ]];
    then
        echo "ProccessMaker 4 is not installed";
        
    else        
        
        ##### install processmaker #####
        pm_var=$(echo "${PM_URL}" | tr "/" "\n" | grep  "tar.gz") ;
        cd /tmp/ && rm -rf ${pm_var} ;        
        wget ${PM_URL} ;
        
        tar -C /opt -xzvf ${pm_var} ;
        cd /opt ;
        #pm_var_sp=$(echo "${pm_var}" | cut -d"." -f1) ;
        #echo ${pm_var_sp} ;
        #mv ${pm_var_sp} processmaker ;
        #rm -rf /tmp/${pm_var} ;
        cd /opt/processmaker ;
        php artisan processmaker:install ;
        cd /opt/processmaker ;
        php artisan storage:link ;
        npm install laravel-echo-server ;
        sed -i '/"protocol": "https",/c\"protocol": "http",' /opt/processmaker/laravel-echo-server.json ;
        sed -i '/"sslCertPath": "\/etc\/nginx\/ssl\/processmaker.local.processmaker.com.crt",/c\"sslCertPath": "",' /opt/processmaker/laravel-echo-server.json ;
        sed -i '/"sslKeyPath": "\/etc\/nginx\/ssl\/processmaker.local.processmaker.com.key",/c\"sslKeyPath": "",' /opt/processmaker/laravel-echo-server.json ;
        sed -i 's/DB_HOSTNAME/DB_HOST/' /opt/processmaker/.env ;
        chgrp -R nginx storage bootstrap/cache ;
        chmod -R ug+rwx storage bootstrap/cache ;
         
        mkdir /opt/processmaker/tmp ;
        echo "HOME=/opt/processmaker" >> /opt/processmaker/.env ;
        echo "PROCESSMAKER_SCRIPTS_HOME=/opt/processmaker/tmp" >> /opt/processmaker/.env ;
        echo "DOCKER_HOST_URL=https://pm4-install-example.processmaker.net" >> /opt/processmaker/.env ;
        echo "MAIL_FROM_ADDRESS=no-reply@processmaker.net" >> /opt/processmaker/.env ;
        echo "MAIL_FROM_NAME=no-reply@processmaker.net" >> /opt/processmaker/.env ;
        chown -R nginx:nginx /opt/processmaker ;
    fi