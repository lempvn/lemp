#!/bin/bash

clear
echo "========================================================================="
echo "---------------------------- LEMP -------------------------------"
if [ -f /etc/lemp/lemp.version ]; then
echo "LEMP version: "$(cat /etc/lemp/lemp.version)
fi
echo "------------------------------ PHP --------------------------------"
echo "PHP version: "$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
echo "------------------------- phpmyadmin ------------------------------"
if [ -f /etc/lemp/phpmyadmin.version ]; then
echo "phpmyadmin version: "$(cat /etc/lemp/phpmyadmin.version)
fi
echo "------------------------------ LDD --------------------------------"
ldd --version
echo "----------------------------- nginx -------------------------------"
nginx -V
echo "---------------------------- openssl ------------------------------"
openssl version
echo "========================================================================="

/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
