#!/bin/bash

. /opt/vps_lemp/script/lemp/nginx-setup.conf
echo $moduledir
echo $opensslversion
echo $withopensslopt
echo $zlibversion
echo $pcreVersionInstall
echo $Nginx_VERSION
#exit
echo "Install after 3s"
sleep 3

/opt/vps_lemp/script/lemp/menu/nginx-setup-download.sh


. /opt/vps_lemp/script/lemp/nginx-setup.conf

