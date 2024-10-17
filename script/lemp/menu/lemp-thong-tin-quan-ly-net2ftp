#!/bin/sh
. /home/lemp.conf
if [ ! -f /etc/lemp/net2ftpsite.info ]; then
clear
echo "========================================================================="
echo "Ban chua cai dat domain Net2FTP cho Server !"
/etc/lemp/menu/21_net2ftp/lemp-net2ftp-menu
exit
fi
echo "Please wait..."; sleep 1
net2ftpsite=$(cat /etc/lemp/net2ftpsite.info)
clear
echo "========================================================================="
echo "Domain Net2FTP: $net2ftpsite"
/etc/lemp/menu/21_net2ftp/lemp-net2ftp-menu
