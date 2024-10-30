#!/bin/bash
. /home/lemp.conf
echo "Please wait..."; sleep 1
clear
echo "========================================================================="
echo "Thong tin user Root cua MySQL:"
echo "-------------------------------------------------------------------------"
echo "User: root"
echo "-------------------------------------------------------------------------"
echo "Password: $mariadbpass"
/etc/lemp/menu/4_database/lemp-them-xoa-database.sh
