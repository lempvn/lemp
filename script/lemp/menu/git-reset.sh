#!/bin/sh

echo "-------------------------------------------------------------------------"
echo "Ok ! please wait check reset code from git..."

cd ~
if [ -d /opt/vps_lemp ]; then
rm -rf /opt/vps_lemp/*
rm -rf /opt/vps_lemp
sleep 5
fi

/etc/lemp/menu/git-clone.sh
sleep 1

clear
echo "========================================================================="
echo "Done! Reset code from git..."
/etc/lemp/menu/lemp-update-upgrade-service-menu.sh
