#!/bin/sh
. /home/lemp.conf
echo "========================================================================="
echo "Prepare run TOP C command"
echo "-------------------------------------------------------------------------"
echo "Quit top c by type "q" in keyboard !"
echo "-------------------------------------------------------------------------"
read -p "Press [Enter] to continue ..."
top -c
