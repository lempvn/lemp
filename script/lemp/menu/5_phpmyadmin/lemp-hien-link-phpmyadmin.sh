#!/bin/bash
. /home/lemp.conf
echo "-------------------------------------------------------------------------"
echo "Please wait..."; sleep 1
clear
echo "========================================================================="
echo "Ban Co The Truy Cap Vao Phpmyadmin Bang Link Duoi:"
echo "-------------------------------------------------------------------------"
echo "http://$serverip:$priport"
/etc/lemp/menu/5_phpmyadmin/lemp-phpmyadmin-menu.sh