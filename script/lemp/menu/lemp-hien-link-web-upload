#!/bin/sh
. /home/lemp.conf
if [ ! -f /etc/lemp/uploadsite ]; then
clear
echo "========================================================================="
echo "Ban chua cai dat File Manager cho Server !"
/etc/lemp/menu/20_file-manager/lemp-web-upload-menu
exit
fi
echo "Please wait..."; sleep 1
uploadsite=$(cat /etc/lemp/uploadsite)
clear
echo "========================================================================="
echo "Domain cai dat File Manager cho Server: "
echo "-------------------------------------------------------------------------"
echo "http://$uploadsite "
/etc/lemp/menu/20_file-manager/lemp-web-upload-menu
